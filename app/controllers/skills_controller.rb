class SkillsController < ApplicationController

  add_breadcrumb "Home", :root_path, :options => { :title => "Home" }
  add_breadcrumb "Attacks Index", :skills_path

  def index
    @skills = Skill.all.order('name ASC').page(params[:page]).per(50)
  end

  def show
    @skills = Skill.find(params[:id])
    add_breadcrumb "Detail Skill", :skill_path
  end

  def new
    # @skills = Skill.all
    @element = Skill.distinct.pluck(:element_type)
    @skill = Skill.new
    # @skill = Skill.new
    add_breadcrumb "New Attack", :new_skill_path
  end

  def create
    @skill = Skill.new(skill_params)
    if @skill.save
      flash[:success] = "New skill was successfully created"
      redirect_to skills_path(@skill)
     else
      puts 'ERROR ', @skill.errors.full_messages
      flash[:danger] = @skill.errors.full_messages
      redirect_to skills_path
     end
  end

  def edit
    @skill = Skill.find_by(id: params[:id])
    add_breadcrumb "Edit Attack", :edit_skill_path
  end

  def update
    @skill = Skill.find_by(id: params[:id])
    @skill.update(skill_params)
    redirect_to skills_path
  end

  def destroy
    @skill = Skill.find_by(id: params[:id])
    if @skill.destroy
      flash[:danger] = "Skill was successfully deleted"
      redirect_to skills_path(@skill)
     else
      puts 'ERROR ', @skill.errors.full_messages
      flash[:danger] = @skill.errors.full_messages
      redirect_to skills_path
    end
  end




  private

  def skill_params
    params.require(:skill).permit(:name, :power, :max_pp, :element_type)
  end


end
