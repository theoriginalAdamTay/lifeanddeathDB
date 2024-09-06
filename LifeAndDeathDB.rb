require 'sqlite3'

class LifeAndDeathDB
    def initialise
        @db = SQLite3::Database.new "lifeanddeath.db"
        create_table
    end

    def create_table
        @db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS people (
        id INTEGER PRIMARY KEY,
        firstName TEXT,
        lastName TEXT,
        dob TEXT,
        status TEXT
        );
        SQL
    end

    def add_person(firstName, lastName, dob, status)
        @db.execute "INSERT INTO people (firstName, lastName, dob, status) VALUES (?, ?, ?, ?)", [firstName, lastName, dob, status]
        puts "Person added: #{firstName} #{lastName}, Date of birth: #{dob}, Status: #{status}"
    end

    def list_people
        puts "\nListing all people:"
        people = @db.execute "SELECT * FROM people"
        if people.empty?
            puts "No people found in the database"
        else
            people.each do |person|
                puts "ID: #{person[0]} | Name: #{person[1]} #{person[2]} | Date of birth: #{person[3]} | Status: #{person[4]}"
            end
        end
    end

    def update_person(id, firstName, lastName, dob, status)
        @db.execute "UPDATE people SET firstName = ?, lastName = ?, dob = ?, status = ? WHERE id = ?", [firstName, lastName, dob, status, id]
        puts "Person with ID #{id} updated"
    end

    def delete_person(id)
        @db.execute "DELETE FROM people WHERE id = ?", [id]
        puts "Person with ID #{id} deleted"
    end

    def find_person(id)
        person = @db.execute "SELECT * FROM people WHERE id = ?", [id]
        if person.empty?
            puts "Person with ID #{id} not found"
        else
            person.each do |p|
                puts "ID: #{p[0]} | Name: #{p[1]} #{p[2]} | Date of birth: #{p[3]} | Status: #{p[4]}"
            end
        end
    end
end

class CLI
    def initialise
        @db = LifeAndDeathDB.new
    end

    def start
        loop do
            puts "\nThe Database of Life and Death"
            puts "1. Add person to database"
            puts "2. List people in database"
            puts "3. Update person in database"
            puts "4. Delete person from database"
            puts "5. Find person in database"
            puts "6. Exit the program"
            print "Choose an option: "

            choice = gets.chomp.to_i
            case choice
            when 1
                add_person
            when 2
                @db.list_people
            when 3
                update_person
            when 4
                delete_person
            when 5
                find_person
            when 6
                puts "Exiting the program..."
                break
            else
                puts "Invalid choice, please try again"
            end
        end
    end

    def add_person
        print "Enter first name: "
        firstName = gets.chomp
        print "Enter last name: "
        lastName = gets.chomp
        print "Enter date of birth in YYYY-MM-DD format: "
        dob = gets.chomp
        print "Enter status: "
        status = gets.chomp
        @db.add_person(firstName, lastName, dob, status)
    end

    def update_person
        print "Enter ID of the person to update: "
        id = gets.chomp.to_i
        print "Enter new first name: "
        firstName = gets.chomp
        print "Enter new last name: "
        lastName = gets.chomp
        print "Enter new date of birth in YYYY-MM-DD format: "
        dob = gets.chomp
        print "Enter new status: "
        status = gets.chomp
        @db.update_person(id, firstName, lastName, dob, status)
    end

    def delete_person
        print "Enter ID of the person to delete: "
        id = gets.chomp.to_i
        @db.delete_person(id)
    end

    def find_person
        print "Enter ID of the person to find: "
        id = gets.chomp.to_i
        @db.find_person(id)
    end
end

CLI.new.start

