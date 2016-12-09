class Admin::ResumesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_is_admin
  layout 'admin'

  def index
      @job = Job.find(params[:job_id])
      @resumes = @job.resumes.order('created_at DESC')
  end

  def show
    @job = Job.find(params[:job_id])
    @resume = Resume.find(params[:id])
    respond_to do |format|
      format.html { render :template => "resumes/show" }
      format.pdf {
        html = render_to_string(:layout => false , :action => "show.pdf.erb") # your view erb files goes to :action

        kit = PDFKit.new(html)
        kit.stylesheets << "#{Rails.root}/public/stylesheets/pdf.css"
        send_data(kit.to_pdf, :filename=>"#{@resume.id}.pdf",
          :type => 'application/pdf', :disposition => 'inline')
    }

    end
  end

  def require_is_admin
    if !current_user.admin?
      flash[:alert] = 'You are not admin'
      redirect_to root_path
    end
  end
end
