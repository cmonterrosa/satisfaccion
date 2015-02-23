class HomeController < ApplicationController
  #layout 'principal'
  layout 'principal_raiting'
  
  def index
    @calificacion = Calificacion.new
  end

  def show
    #@issue = Issue.find(params[:calificacion][:issue_id]) if params[:calificacion][:issue_id].size > 0
    if params[:calificacion][:issue_id].size > 0
      @issue = Issue.find(:first,
                        :conditions => ["id = ? AND status_id NOT IN (select id from issue_statuses where name in ('Calificada'))", params[:calificacion][:issue_id] ])
    end
    unless @issue
      flash[:error] = "No existe un servicio con ese folio o ya fue capturado anteriormente"
      redirect_to :action => "index"
    end
 
  end

  def save
    ip = request.env['REMOTE_ADDR']
    ip ||= request.env['HTTP_X_FORWARDED_FOR']
    @issue = Issue.find(params[:id])
    @calificacion ||= Calificacion.find_by_issue_id(@issue.id)
    @calificacion ||= Calificacion.new
    @calificacion.calificacion = params[:raiting].to_i if params[:raiting]
    @calificacion.update_attributes(params[:calificacion]) if @calificacion
    @calificacion.direccion_ip= ip if ip
    @calificacion.issue_id = @issue.id if @issue
    @calificacion.user_id = User.find(@issue.assigned_to_id).id if @issue
    if @calificacion.save
      @issue.establish_status_calificada
      flash[:notice] = "Servicio #{@issue.id} calificado, gracias por su participación"
      redirect_to :action => "index", :controller => "home"
    else
      flash[:error] = "Ocurrió un error, verifique"
      render :action => "show"
    end
  end

end
