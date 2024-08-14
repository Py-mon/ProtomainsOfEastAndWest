--!strict

local button = script.Parent
local Folder = button.Parent

local rep = game:GetService("ReplicatedStorage")

local anim = require(rep.Modules.Animations.ButtonAnim)

anim.addClickAnim(button, Folder, 1.15, button.Size)
