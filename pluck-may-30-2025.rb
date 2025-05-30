Taken From https://guides.rubyonrails.org/active_record_querying.html#pluck

19.2. pluck
pluck can be used to pick the value(s) from the named column(s) in the current relation. It accepts a list of column names as an argument and returns an array of values of the specified columns with the corresponding data type.

irb> Book.where(out_of_print: true).pluck(:id)
SELECT id FROM books WHERE out_of_print = true
=> [1, 2, 3]

irb> Order.distinct.pluck(:status)
SELECT DISTINCT status FROM orders
=> ["shipped", "being_packed", "cancelled"]

irb> Customer.pluck(:id, :first_name)
SELECT customers.id, customers.first_name FROM customers
=> [[1, "David"], [2, "Fran"], [3, "Jose"]]
Copy
pluck makes it possible to replace code like:

Customer.select(:id).map { |c| c.id }
# or
Customer.select(:id).map(&:id)
# or
Customer.select(:id, :first_name).map { |c| [c.id, c.first_name] }
Copy
with:

Customer.pluck(:id)
# or
Customer.pluck(:id, :first_name)
Copy
Unlike select, pluck directly converts a database result into a Ruby Array, without constructing ActiveRecord objects. This can mean better performance for a large or frequently-run query. However, any model method overrides will not be available. For example:

class Customer < ApplicationRecord
  def name
    "I am #{first_name}"
  end
end
Copy
irb> Customer.select(:first_name).map &:name
=> ["I am David", "I am Jeremy", "I am Jose"]

irb> Customer.pluck(:first_name)
=> ["David", "Jeremy", "Jose"]
Copy
You are not limited to querying fields from a single table, you can query multiple tables as well.

irb> Order.joins(:customer, :books).pluck("orders.created_at, customers.email, books.title")
Copy
Furthermore, unlike select and other Relation scopes, pluck triggers an immediate query, and thus cannot be chained with any further scopes, although it can work with scopes already constructed earlier:

irb> Customer.pluck(:first_name).limit(1)
NoMethodError: undefined method `limit' for #<Array:0x007ff34d3ad6d8>

irb> Customer.limit(1).pluck(:first_name)
=> ["David"]
Copy
You should also know that using pluck will trigger eager loading if the relation object contains include values, even if the eager loading is not necessary for the query. For example:

irb> assoc = Customer.includes(:reviews)
irb> assoc.pluck(:id)
SELECT "customers"."id" FROM "customers" LEFT OUTER JOIN "reviews" ON "reviews"."id" = "customers"."review_id"
Copy
One way to avoid this is to unscope the includes:

irb> assoc.unscope(:includes).pluck(:id)
