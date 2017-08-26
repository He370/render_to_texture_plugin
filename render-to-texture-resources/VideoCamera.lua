
require 'core/appkit/lua/class'
require 'core/appkit/lua/app'

local SimpleProject = require 'core/appkit/lua/simple_project'
local Application = stingray.Application

VideoCamera = Appkit.class(VideoCamera)

function VideoCamera:init(world)
  VideoCamera.world = world
  VideoCamera.viewport = Application.create_viewport(world, "default")
  VideoCamera.camera_viewport = Application.create_viewport(world, "camera_viewport")
  VideoCamera.camera_unit = stingray.World.spawn_unit(world, SimpleProject.config.camera_unit)
  VideoCamera.camera = stingray.Unit.camera(VideoCamera.camera_unit, 1)

  Application.set_render_setting("taa_enabled", "false")
end

function VideoCamera:update_camera_pose(pose)
  stingray.Unit.set_local_pose(self.camera_unit,1,pose)
end

function VideoCamera:render()
  local shading_env = Appkit.managed_world.shading_env
  if self.camera ~= nil then
    Application.render_world(self.world, self.camera, self.viewport, shading_env)
    Application.render_world(self.world, self.camera, self.camera_viewport, shading_env)
  end
end

function VideoCamera:render_vr()
  local shading_env = Appkit.managed_world.shading_env
  if self.camera ~= nil then
    Application.set_render_setting("vr_enabled", "false")
    Application.set_render_setting("vr_mask_enabled", "false")
    Application.render_world(self.world, self.camera, self.viewport, shading_env)
    Application.render_world(self.world, self.camera, self.camera_viewport, shading_env)
    Application.set_render_setting("vr_enabled", "true")
    Application.set_render_setting("vr_mask_enabled", "true")
  end
end

return VideoCamera
