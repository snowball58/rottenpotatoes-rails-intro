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
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    @ratings = params[:ratings]
    if not @ratings
      @movies = Movie.all
    else 
      @movies = Movie.where(:rating => @ratings.keys)
    end
  end
  
  def titlesort
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    @movies = Movie.order(:title)
  end
  
  def datesort
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    @movies = Movie.order(:release_date)
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
