require 'test_helper'

class Admin::ImagesControllerTest < ActionController::TestCase

  setup do
    set_default_settings
    sign_in users(:admin)
  end

  test "Should be able to create an image" do
    assert_difference 'Image.count', +1 do
      post :create,
        image: {
          name: name,
          file: uploaded_file_object(Image, :file, file)
        },
        format: 'json'
    end
  end

  test "Should be able to delete an image" do
    @image = Image.create(name: 'test')
    assert_difference 'Image.count', -1 do
      delete :destroy,
        id: @image.id,
        format: 'json'
    end
  end

end
