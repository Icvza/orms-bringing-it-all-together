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

    def save
        sql = <<-SQL
        INSERT INTO dogs (name, breed) 
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self
    end

    def update
    end

    def self.find_by_name(name)
        sql = "SELECT * FROM dogs WHERE name = ?"
        result = DB[:conn].execute(sql, self.name, self.breed, self.id)
    end


end
