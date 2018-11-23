module UsersHelper
    def gravatar_for(user, size="100")
        avatar = if user.avatar.blank? then "/gravatarlogo.jpg" else user.avatar end
        image_tag(avatar, alt: user.name, class: "gravatar", size: size)
      end
end
