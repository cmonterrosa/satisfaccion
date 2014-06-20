class CreateCalificacions < ActiveRecord::Migration
  def self.up
    create_table :calificacions do |t|
      t.integer :issue_id
      t.integer :user_id
      t.boolean :cumplio_expectativas
      t.string :nombre
      t.integer :calificacion
      t.string :observaciones, :limit => 100
      t.string :direccion_ip, :limit => 20
      t.timestamps
    end

  ############# Nuevos registros ####################
  IssueStatus.create(:name => "Calificada", :is_closed => false, :is_default => false, :position => 6) unless IssueStatus.find_by_name("Calificada")
  old_status = IssueStatus.find_by_name("Calificada")
  new_status = IssueStatus.find_by_name("Cerrada")
  jefe_dpto = Role.find_by_name("Jefe de Departamento")
  Tracker.find(:all).each do |t|
    Workflow.create(:tracker_id => t.id, :old_status_id => old_status.id, :new_status_id => new_status.id, :role_id => jefe_dpto.id, :assignee => 0, :author => 0)
  end
end

  def self.down
    drop_table :calificacions
  end
end
