require "insert/version"
require 'murmurhash3'
require 'pg'

class Insert
  attr_reader :connection
  def initialize(connection)
    connection.is_a?(PG::Connection) or raise ArgumentError, "expected PG::Connection, got #{connection.inspect}"
    @connection = connection
    @statements = {}
  end

  def insert(quoted_table_name, attrs)
    raise "can't insert if already deallocated!" if @deallocated
    attrs = attrs.map do |k, v|
      [ k.to_s, v ]
    end.sort_by { |k, _| k }
    attrs = Hash[attrs]
    connection.exec_prepared statement_for(quoted_table_name, attrs.keys), attrs.values
  end

  def deallocate
    raise "can't deallocate if already deallocated!" if @deallocated
    @deallocated = true
    @statements.each do |_, name|
      connection.exec "DEALLOCATE #{name}"
    end
  end

  private

  def statement_for(quoted_table_name, cols)
    @statements[[quoted_table_name, cols]] ||= begin
      name = 'insert_' + MurmurHash3::V128.str_hexdigest(cols.join("\0"))
      quoted_cols = cols.map { |col| connection.quote_ident col }
      bind_params = cols.length.times.map { |i| "$#{i+1}" }
      statement = %{INSERT INTO #{quoted_table_name} (#{quoted_cols.join(',')}) VALUES (#{bind_params.join(',')})}
      begin
        connection.prepare name, statement
      rescue PG::DuplicatePstatement
        # noop
      end
      name
    end
  end

end

=begin
conn = PG.connect(:dbname => 'db1')
conn.prepare('statement1', 'insert into table1 (id, name, profile) values ($1, $2, $3)')
conn.exec_prepared('statement1', [ 11, 'J.R. "Bob" Dobbs', 'Too much is always better than not enough.' ])
=end
