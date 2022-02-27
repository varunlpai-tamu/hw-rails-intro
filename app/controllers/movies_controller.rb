class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @title_class = 'text-info'
      @release_class = 'text-info'
      
      @movies = Movie.all
      @all_ratings = Movie.distinct.pluck(:rating)
      
      unless session.key?(:ratings)
        session[:ratings] = Movie.distinct.pluck(:rating)
      end
      unless session.key?(:column)
        session[:column] = ''
      end
      
      if params.key?(:ratings)
        session[:ratings] = params[:ratings].keys
      end
      if params.key?(:column)
        if session[:column] == params[:column]
          session[:column] = ''
        else
          session[:column] = params[:column]
        end
      end
        
      @movies = @movies.where(rating: session[:ratings])
      @ratings = session[:ratings]
      
      if session[:column] == 'Title'
        @movies = @movies.order('title': :asc)
        @title_class = 'hilite text-dark'
      elsif session[:column] == 'Release'
        @movies = @movies.order('release_date': :asc)
        @release_class = 'hilite text-dark'
      end
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end