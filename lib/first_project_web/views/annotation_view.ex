defmodule FirstProjectWeb.AnnotationView do
  use FirstProjectWeb, :view
  def render("annotation.json", %{annotation: ann}) do
    %{
      id: ann.id,
      body: ann.body,
      at: ann.at,
      user: render_one(ann.user, FirstProjectWeb.UserView, "user.json")
    }
  end
end
