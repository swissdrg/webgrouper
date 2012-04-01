# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "drg", :primary_key => "DrID", :force => true do |t|
    t.integer "DrFKSyID",                                                  :null => false
    t.string  "DrCode",                  :limit => 10,                     :null => false
    t.string  "DrName",                  :limit => 500,                    :null => false
    t.float   "cost_weight",                            :default => 0.0,   :null => false
    t.float   "avg_duration",                           :default => 0.0,   :null => false
    t.integer "first_day_discount",                     :default => 0,     :null => false
    t.float   "discount_per_day",                       :default => 0.0,   :null => false
    t.integer "first_day_surcharge",                    :default => 0,     :null => false
    t.float   "surcharge_per_day",                      :default => 0.0,   :null => false
    t.boolean "transfer",                               :default => false, :null => false
    t.float   "transfer_flatrate",                      :default => 0.0,   :null => false
    t.string  "house",                   :limit => 10,  :default => "1",   :null => false
    t.boolean "exception_from_reuptake",                :default => false, :null => false
  end

  add_index "drg", ["DrCode", "DrFKSyID"], :name => "DrxCode"
  add_index "drg", ["DrFKSyID"], :name => "FK_drg_1"

  create_table "drgname", :id => false, :force => true do |t|
    t.integer "DnFkDrID",                :null => false
    t.string  "DnLang",   :limit => 10,  :null => false
    t.string  "DnName",   :limit => 500, :null => false
  end

  create_table "icd", :primary_key => "IcID", :force => true do |t|
    t.integer "IcFKSyID",                :null => false
    t.string  "IcCode",   :limit => 10,  :null => false
    t.string  "IcShort",  :limit => 8,   :null => false
    t.string  "IcName",   :limit => 500, :null => false
  end

  add_index "icd", ["IcCode", "IcFKSyID"], :name => "IcxCode"
  add_index "icd", ["IcFKSyID"], :name => "FK_icd_1"
  add_index "icd", ["IcShort", "IcFKSyID"], :name => "IcxShort"

  create_table "icdname", :id => false, :force => true do |t|
    t.integer "InFkIcID",                :null => false
    t.string  "InLang",   :limit => 10,  :null => false
    t.string  "InName",   :limit => 500, :null => false
  end

  create_table "mdc", :force => true do |t|
    t.string  "mdc",    :limit => 123,                   :null => false
    t.string  "text",                  :default => "",   :null => false
    t.string  "lang",                  :default => "DE", :null => false
    t.integer "system",                                  :null => false
  end

  create_table "ops", :primary_key => "OpID", :force => true do |t|
    t.integer "OpFkSyID",                                   :null => false
    t.string  "OpCode",   :limit => 10,                     :null => false
    t.string  "OpShort",  :limit => 8,                      :null => false
    t.string  "OpName",   :limit => 500,                    :null => false
    t.string  "OrNor",                                      :null => false
    t.boolean "side",                    :default => false, :null => false
  end

  add_index "ops", ["OpCode", "OpFkSyID"], :name => "OpxCode"
  add_index "ops", ["OpFkSyID"], :name => "FK_ops_1"
  add_index "ops", ["OpShort", "OpFkSyID"], :name => "OpxShort"

  create_table "opsname", :id => false, :force => true do |t|
    t.integer "OnFkOpID",                :null => false
    t.string  "OnLang",   :limit => 10,  :null => false
    t.string  "OnName",   :limit => 500, :null => false
  end

  create_table "supplement", :id => false, :force => true do |t|
    t.integer "system",                     :null => false
    t.string  "fee",         :limit => 20,  :null => false
    t.float   "amount",                     :null => false
    t.string  "description", :limit => 256, :null => false
  end

  create_table "supplement_ops", :id => false, :force => true do |t|
    t.string  "fee",    :limit => 20, :null => false
    t.string  "ops",    :limit => 20, :null => false
    t.integer "system",               :null => false
  end

  create_table "system", :primary_key => "SyID", :force => true do |t|
    t.string "SyName",     :limit => 45, :null => false
    t.string "SyCatProcs", :limit => 45, :null => false
    t.string "SyCatDiags", :limit => 45, :null => false
  end

end
