require 'bundler/setup'
Bundler.require
if development?
    ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User < ActiveRecord::Base
    has_secure_password
    validates :name,
        presence: true,
        format: {with: /\A\w+\z/ }
    validates :password,
        length: { in: 5..15}
    has_many :counters
    has_many :counts, through: :counters
end

class Count < ActiveRecord::Base
  has_many :counters
  has_many :users, through: :counters
end

class Counter < ActiveRecord::Base
  belongs_to :user
  belongs_to :count
end