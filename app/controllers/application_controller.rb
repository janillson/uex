class ApplicationController < ActionController::Base
  include JsonResponse
  include Pagy::Backend
end
