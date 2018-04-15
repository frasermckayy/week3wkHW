require_relative("../db/sql_runner")
require_relative("film.rb")

require("pry-byebug")

class Customer

  attr_reader :id
  attr_accessor :name, :funds


  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @name = options["name"]
    @funds = options["funds"]
  end

  #CRUD
  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id;"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first()
    @id = customer["id"].to_i
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3;"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM customers"
    values = []
    SqlRunner.run(sql, values)
    result = Customer.map_customers(customers)
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    values = []
    SqlRunner.run(sql, values)
  end

  def film()
    sql = "SELECT films.* FROM films INNER JOIN tickets ON
    films.id = tickets.film_id WHERE tickets.customer_id = $1;"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return films.map{|film| Film.new(film)}
  end

  #mapping
  def self.map_customers(customer_data)
    return customer_data.map{|customer_hash| Customer.new(customer_hash)}
  end

  #showing that a customer has booked a ticket
  def films_booked()
    sql = "SELECT films.* FROM films INNER JOIN tickets ON films.id = tickets.film_id
    WHERE tickets.customer_id = $1;"
    values = [@id]
    return SqlRunner.run(sql, values).map { |film| film['title'] }
  end

  #customer buying ticket
  def purchase_ticket(film)
    @funds -= film.price()
    update()
    return @funds
  end
  #how many tickets were purchased by one customer
  def tickets_purchased()
    return films_booked.length()
  end



end
