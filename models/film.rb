require_relative("../db/sql_runner")
require_relative("customer.rb")


class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @title = options["title"]
    @price = options["price"].to_i
  end

  #CRUD
  def save()
    sql = "INSERT INTO film (title, price) VALUES ($1, $2) RETURNING id;"
    values = [@title, @price]
    film = SqlRunner.run(sql, values)
    result = Film.map_films(films)
    return result
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3;"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM films;"
    values = []
    films = SqlRunner.run(sql, values)
    result = Film.map_films(films)
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM films;"
    values = []
    SqlRunner.run(sql, values)
  end

  def customer()
    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON
    customers.id = tickets_id WHERE tickets.film_id = $1;"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return Customer.map_customers(customers)
  end

  #mapping
  def self.map_films(film_data)
    return film_data.map{|film_hash| Film.new(film_hash)}
  end

  #which customers are coming to see the film
  def customer_attendance()
    sql = "SELECT customer.* FROM customers AS customer INNER JOIN tickets ON customer.id = tickets.customer_id
    WHERE tickets.film_id = $1;"
    values = [@id]
    return SqlRunner.run(sql, values).map { |customer| customer['name'] }
  end

  #how many tickets were sold for each film
  def tickets_sold()
    return customer_attendance.length
  end

end
