class Issue < ActiveRecord::Base
  def no_calificado_or_cerrado?
   @issue = Issue.find(:first, :conditions => ["id = ? AND status_id NOT IN (select id from issue_statuses where name in ('Cerrada', 'Calificada'))", self.id ])
   (@issue) ? true : nil
  end
  def establish_status_calificada
    @calificada = IssueStatus.find_by_name("Calificada")
    @issue = Issue.find(self.id)
    @issue.update_attributes!(:status_id => @calificada.id) if @issue && @calificada
  end

end
