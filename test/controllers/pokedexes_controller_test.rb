require "test_helper"

class PokedexesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pokedexes_index_url
    assert_response :success
  end

  test "should get show" do
    get pokedexes_show_url
    assert_response :success
  end
end
