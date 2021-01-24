class Dog
    attr_accessor :id, :name, :breed 
    def initialize(attributes={})
        attributes.each {|key, value| 
        self.send(("#{key}="), value)}
    end

    def self.create_table
        sql = <<-DOC
        CREATE TABLE IF NOT EXISTS dogs (
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
        )
        DOC
        DB[:conn].execute(sql)
    end

    def self.drop_table
        sql = <<-DOC
        DROP TABLE dogs
        DOC
        DB[:conn].execute(sql)
    end

    def self.new_from_db(row)
        new_dog = self.new
        new_dog.id = row[0]
        new_dog.name = row[1]
        new_dog.breed = row[2]
        new_dog        
        # binding.pry 
    end

    def update
        sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
        DB[:conn].execute(sql, self.name, self.breed, self.id)
    end

    def save
        sql = <<-SQL
        INSERT INTO dogs (name, breed) 
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self
    end

    def self.create(name:, breed:)
        dog = Dog.new(name:name, breed:breed)
        dog.save 
        dog
    end 

    def self.find_by_name(name)
        sql = "SELECT * FROM dogs WHERE name = ?"
        result = DB[:conn].execute(sql, self.name, self.breed, self.id)
    end

    def self.find_or_create_by(name:, breed:)
        dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
        if !dog.empty?
            dog_data = dog[0]
            dog = Dog.new(id:dog_data[0], name:dog_data[1], breed:dog_data[2])
        else
            dog = self.create(name: name, breed: breed)
        end
        dog
    end
    
    def self.find_by_name(name)
        sql = "SELECT * FROM dogs WHERE name = ?"
        result = DB[:conn].execute(sql, name)[0]
        Dog.new(id:result[0], name:result[1], breed:result[2])
    end

    def self.find_by_id(id)
        sql = "SELECT * FROM dogs WHERE id = ?"
        result = DB[:conn].execute(sql, id)[0]
        Dog.new(id:result[0], name:result[1], breed:result[2])
    end


end
