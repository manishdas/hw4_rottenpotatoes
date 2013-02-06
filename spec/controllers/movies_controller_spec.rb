
require 'spec_helper'

describe MoviesController do
  fixtures :movies
  
  describe 'displaying movies' do
    it 'should show detail of a movie' do
      get :show, {:id => 1}
      response.should render_template(:show)
      assigns(:movie).title.should == 'Star Wars'
    end
    
    context 'index' do
      it 'should redirect if params doesnt match with session' do
        get :index, {:ratings => {'PG'=>1, 'R'=>1}}
        response.should redirect_to movies_path(:ratings=>{'PG'=>1, 'R'=>1})
      end
      
      it 'should show movies ordered by title' do
        get :index, {:sort=>'title', :ratings => {'PG'=>1, 'R'=>1}}, {:sort=>'title', :ratings => {'PG'=>1, 'R'=>1}}
        assigns(:title_header).should == 'hilite'
        assigns(:date_header).should be_nil
        # response.should render_template(:index)
      end
      
      it 'should show movoies ordered by release date' do
        get :index, {:sort=>'release_date', :ratings => ['PG', 'R']}
        assigns(:date_header).should == 'hilite'
        assigns(:title_header).should be_nil
      end
    end
  end
  
  describe 'creating movies' do
    it 'should show new movie form' do
      get :new
      response.should render_template(:new)
    end
    
    it 'should create new entry' do
      post :create, {:movie => {:title=>'test Movie', :rating => 'R', :release_date=> 10.years.ago, :director => 'valo manush'}}
      response.should redirect_to movies_path
      Movie.find_by_title('test Movie').should_not be_nil
    end
  end
  
  describe 'updating movies' do
    it 'should shoe edit movie form' do
      get :edit, {:id => 1}
      response.should render_template(:edit)
      assigns(:movie).should_not be_nil
    end
    
    it 'should update movie information' do
      put :update, {:id=>1, :movie=>{:title=>'test Movie'}}
      response.should redirect_to movie_path(1)
      Movie.find_by_id(1).title.should == 'test Movie'
    end
  end
  
  it 'should destroy a movie' do
    delete :destroy, {:id=>1}
    response.should redirect_to movies_path
    Movie.find_by_id(1).should be_nil
  end
  
  describe 'finding similar Movies' do
    it 'should show movies with same director' do
      get :find, {:id => 1}
      assigns(:movies).size.should == 2
      response.should render_template(:find)
    end
    
    it 'should redirect to home page if no match found' do
      get :find, {:id => 2}
      response.should redirect_to movies_path
    end
  end
end 
