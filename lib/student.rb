require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade, :id

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
      )
      SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
  end

  def self.new_from_db(row)
    row.flatten
    Student.new(row[0], row[1], row[2])

  end

  def update
    sql = "UPDATE students SET name = ?, grade = ?"
    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    student = DB[:conn].execute(sql, name).flatten
    # binding.pry
    Student.new_from_db(student)
  end



end
