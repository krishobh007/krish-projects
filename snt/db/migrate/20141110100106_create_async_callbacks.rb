class CreateAsyncCallbacks < ActiveRecord::Migration
  def change
    create_table :async_callbacks do |t|
      t.text :request
      t.text :response
      t.references :origin, :polymorphic => true

      t.timestamps
    end
  end
end
