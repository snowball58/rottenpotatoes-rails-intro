class MoviesController < ApplicationController
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  # rails s -p $PORT -b $IP
  def index
    @ratings = params[:ratings]
    if not session[:current_user_id]
      session[:current_user_id] = []
      if @ratings
        @movies = Movie.where(:rating => @ratings.keys)
        session[:current_user_id][0] = @ratings
      else
        @movies = Movie.all
      end
    elsif session[:current_user_id][1] === 1
      titlesort
      @title_header = 'hilite'
      @release_date_header = ''
    elsif session[:current_user_id][1] === 2
      datesort
      @release_date_header = 'hilite'
      @title_header = ''
    else
      if @ratings
        @movies = Movie.where(:rating => @ratings.keys)
        session[:current_user_id][0] = @ratings
      elsif session[:current_user_id][0]
        @movies = Movie.where(:rating => session[:current_user_id][0].keys)
      else
        @movies = Movie.all
      end
    end
  end
  
  def titlesort
    @ratings = params[:ratings]
    if (not @ratings) and (not session[:current_user_id][0])
      @movies = Movie.order(:title)
    elsif not @ratings
      @movies = Movie.where(:rating => session[:current_user_id][0].keys).order(:title)
    else 
      @movies = Movie.where(:rating => @ratings.keys).order(:title)
      session[:current_user_id][0] = @ratings
    end
    session[:current_user_id][1] = 1
  end
  
  def datesort
    @ratings = params[:ratings]
    if (not @ratings) and (not session[:current_user_id][0])
      @movies = Movie.order(:release_date)
    elsif not @ratings
      @movies = Movie.where(:rating => session[:current_user_id][0].keys).order(:release_date)
    else 
      @movies = Movie.where(:rating => @ratings.keys).order(:release_date)
      session[:current_user_id][0] = @ratings
    end
    session[:current_user_id][1] = 2
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
