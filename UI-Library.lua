
    local Players           = game:GetService("Players")
    local RunService        = game:GetService("RunService")
    local UserInputService  = game:GetService("UserInputService")
    local TweenService      = game:GetService("TweenService")
    local GuiService        = game:GetService("GuiService")
    
    local LocalPlayer       = Players.LocalPlayer
    
    local LocalMouse 		= LocalPlayer:GetMouse()

    local CurrentInfos = {OneIsShown = false;}
    local UILib = {
        Colors = {
            DarkGray = Color3.fromRGB(170, 170, 170);
            Gray = Color3.fromRGB(235, 235, 235);
            MainColor1 = Color3.fromRGB(30, 30, 42);
            MainColor2 = Color3.fromRGB(17, 17, 24);
            CloseColor = Color3.fromRGB(255, 106, 106);
            ContrastColor = Color3.fromRGB(89, 92, 150);
            White = Color3.fromRGB(255,255,255);
        };
        AddInfo = function(self, Frame, Props, Parent)
            Frame.MouseLeave:Connect(function()
                if CurrentInfos["Frame"] then 
                    CurrentInfos["Frame"]:TweenSize(UDim2.new(0, 0, 0, 25), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1)
                    wait(0.1)
                    if CurrentInfos["Frame"] then CurrentInfos["Frame"]:Destroy() end
                    CurrentInfos["Frame"] = nil
                    CurrentInfos.OneIsShown = false;
                    CurrentInfos.LastPos = nil
                end
            end)
            Frame.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton2 then
                    if CurrentInfos["Frame"] then 
                        CurrentInfos["Frame"]:TweenSize(UDim2.new(0, 0, 0, 25), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1)
                        wait(0.1)
                        if CurrentInfos["Frame"] then CurrentInfos["Frame"]:Destroy() end
                        CurrentInfos["Frame"] = nil
                        CurrentInfos.OneIsShown = false;
                    end
                    CurrentInfos.OneIsShown = true;

                    local Position = (UserInputService:GetMouseLocation() - GuiService:GetGuiInset()) + Vector2.new(20,0)
                    local InfoFrame = Instance.new("Frame")
                    local Title = Instance.new("TextLabel")

                    InfoFrame.Name = "InfoFrame"
                    InfoFrame.ZIndex = 1000;
                    InfoFrame.Parent = Parent
                    InfoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
                    InfoFrame.BorderColor3 = Color3.fromRGB(89, 92, 150)
                    InfoFrame.Position = UDim2.new(0,Position.X,0,Position.Y)
                    InfoFrame.Size = UDim2.new(0, 0, 0, 25)

                    Title.Name = "Title"
                    Title.ZIndex = 1001;
                    Title.Parent = InfoFrame
                    Title.AnchorPoint = Vector2.new(0, 1)
                    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Title.BackgroundTransparency = 1.000
                    Title.Position = UDim2.new(0, 5, 1, 0)
                    Title.Size = UDim2.new(1, -5, 1, 0)
                    Title.Font = Enum.Font.RobotoMono
                    Title.Text = Props.Text
                    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Title.TextSize = 14.000
                    Title.TextXAlignment = Enum.TextXAlignment.Left
                    Title.Visible = false;
                    local Size = UDim2.new(0, Title.TextBounds.X + 10, 0, 25)
                    Title.TextWrapped = true
                    Title.Visible 	  = true;
                    InfoFrame:TweenSize(Size, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1)
                    CurrentInfos.Frame = InfoFrame
                end
            end)
        end
    }
    local Dragger = {}; do
        local inputService = UserInputService;
        local heartbeat    = RunService.Heartbeat;
        -- // credits to Ririchi / Inori for this cute drag function :) // stollen from wally ui :flushed:
        function Dragger.Add(frame)
            local s, event = pcall(function()
                return frame.MouseEnter
            end)

            if s then
                frame.Active = true;

                event:connect(function()
                    local input = frame.InputBegan:connect(function(key)
                        if key.UserInputType == Enum.UserInputType.MouseButton1 then
                            local objectPosition = Vector2.new(LocalMouse.X - frame.AbsolutePosition.X, LocalMouse.Y - frame.AbsolutePosition.Y);
                            while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                pcall(function()
                                    frame:TweenPosition(UDim2.new(0, LocalMouse.X - objectPosition.X, 0, LocalMouse.Y - objectPosition.Y), 'Out', 'Linear', 0.05, true);
                                end)
                            end
                        end
                    end)

                    local leave;
                    leave = frame.MouseLeave:connect(function()
                        input:disconnect();
                        leave:disconnect();
                    end)
                end)
            end
        end
    end

    function UILib:InitUI(title, toggleKey)
        local function Ripple(btn)
            local HoldingMouse = false;
            local MaxHold = 2;
            local CurHold = 0;
            local GettingDestory = false;
            local CurrentlyRunningEffect = false;	

            local rippleEffect = nil
            local rippleEffectInner = nil
            btn.MouseButton1Down:Connect(function()
                if CurrentlyRunningEffect then return end
                HoldingMouse = true
                CurrentlyRunningEffect = true;
                rippleEffect = Instance.new("ImageLabel", btn);
                rippleEffectInner = Instance.new("ImageLabel", rippleEffect);

                rippleEffect.Name = "rippleEffect";
                rippleEffect.BackgroundTransparency = 1;
                rippleEffect.BorderSizePixel = 0;
                rippleEffect.ZIndex = 100;
                rippleEffect.Image = "rbxassetid://2708891598";
                rippleEffect.ImageColor3 = Color3.fromRGB(255, 255, 255);
                rippleEffect.ImageTransparency = 0.85;
                rippleEffect.ScaleType = Enum.ScaleType.Fit;
                rippleEffectInner.Name = "rippleEffect";
                rippleEffectInner.AnchorPoint = Vector2.new(0.5, 0.5);
                rippleEffectInner.BackgroundTransparency = 1;
                rippleEffectInner.BorderSizePixel = 0;
                rippleEffectInner.ZIndex = 101;
                rippleEffectInner.Position = UDim2.new(0.5, 0, 0.5, 0);
                rippleEffectInner.Size = UDim2.new(0.93, 0, 0.93, 0);
                rippleEffectInner.Image = "rbxassetid://2708891598";
                rippleEffectInner.ImageColor3 = Color3.fromRGB(45, 45, 45);
                rippleEffectInner.ImageTransparency = 0.85;
                rippleEffectInner.ScaleType = Enum.ScaleType.Fit;
                rippleEffect.Position = UDim2.new(0, LocalMouse.X - rippleEffect.AbsolutePosition.X, 0, LocalMouse.Y - rippleEffect.AbsolutePosition.Y);
                rippleEffect:TweenSizeAndPosition(UDim2.new(10, 0, 10, 0), UDim2.new(-4.5, 0, -4.5, 0), "Out", "Quad", 0.33);
                while HoldingMouse do 
                    wait(1)
                    CurHold = CurHold + 1
                    if CurHold >= MaxHold then 
                        CurHold = 0;
                        GettingDestory = true;
                        HoldingMouse = false;
                        if rippleEffect then 
                            for i = 1, 10 do
                                rippleEffect.ImageTransparency = rippleEffect.ImageTransparency + 0.01
                                wait()
                            end
                            rippleEffect:Destroy()
                            rippleEffect = nil
                            rippleEffectInner = nil
                            GettingDestory = false;
                        end
                        GettingDestory = false;
                        CurrentlyRunningEffect = false;
                        break 
                    end
                end
            end)
            btn.MouseButton1Up:Connect(function()
                HoldingMouse = false;
                if not GettingDestory then 
                    CurHold = 0;
                    if rippleEffect then 
                        GettingDestory = true;
                        if rippleEffect then 
                            for i = 1, 10 do
                                rippleEffect.ImageTransparency = rippleEffect.ImageTransparency + 0.01
                                wait()
                            end
                            rippleEffect:Destroy()
                            rippleEffect = nil
                            rippleEffectInner = nil
                            GettingDestory = false;
                        end
                        GettingDestory = false;
                        CurrentlyRunningEffect = false;
                    end
                end
            end)
        end
        local function MouseInFrame(uiobject)
            local y_cond = uiobject.AbsolutePosition.Y <= LocalMouse.Y and LocalMouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
            local x_cond = uiobject.AbsolutePosition.X <= LocalMouse.X and LocalMouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

            return (y_cond and x_cond)
        end
        local function CheckForProperty(obj, prop)
            local suc,res = pcall(function()
                return obj[prop]
            end)
            return suc
        end

        local isBinding = false;
        local KeyBinds = {}
        local shortNames = {
            RightControl = 'RightCtrl';
            LeftControl = 'LeftCtrl';
            LeftShift = 'LShift';
            RightShift = 'RShift';
            MouseButton1 = "Mouse1";
            MouseButton2 = "Mouse2";
        }
        local banned = {
            Return = true;
            Space = true;
            Tab = true;
            Unknown = true;
        }

        local allowed = {
            MouseButton1 = true;
            MouseButton2 = true;
        }      

        local UI = Instance.new("ScreenGui")
        local TopFrame = Instance.new("Frame")
        local MainFrame = Instance.new("Frame")
        local SideFrame = Instance.new("Frame")
        local TabButtons = Instance.new("ScrollingFrame")
        local UIListLayout = Instance.new("UIListLayout")
        local UIPadding = Instance.new("UIPadding")
        local TabHolder = Instance.new("Frame")
        local Title = Instance.new("TextLabel")

        UI.Name = "UI"
        UI.Parent = game.CoreGui

        TopFrame.Name = "TopFrame"
        TopFrame.Parent = UI
        TopFrame.BackgroundColor3 = UILib.Colors.ContrastColor
        TopFrame.BorderColor3 = UILib.Colors.ContrastColor
        TopFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
        TopFrame.Size = UDim2.new(0, 450, 0, 25)
        Dragger.Add(TopFrame)

        MainFrame.Name = "MainFrame"
        MainFrame.Parent = TopFrame
        MainFrame.BackgroundColor3 = UILib.Colors.MainColor1
        MainFrame.BorderColor3 = UILib.Colors.ContrastColor
        MainFrame.Position = UDim2.new(0, 0, 0, 25)
        MainFrame.Size = UDim2.new(1, 0, 0, 295)

        SideFrame.Name = "SideFrame"
        SideFrame.Parent = MainFrame
        SideFrame.AnchorPoint = Vector2.new(0, 0.5)
        SideFrame.BackgroundColor3 = UILib.Colors.MainColor2
        SideFrame.BorderSizePixel = 0
        SideFrame.Position = UDim2.new(0, 10, 0.5, 0)
        SideFrame.Size = UDim2.new(0.268000007, 0, 1, -20)

        TabButtons.Name = "TabButtons"
        TabButtons.Parent = SideFrame
        TabButtons.Active = true
        TabButtons.AnchorPoint = Vector2.new(1, 1)
        TabButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabButtons.BackgroundTransparency = 1.000
        TabButtons.Position = UDim2.new(1, 0, 1, 0)
        TabButtons.Size = UDim2.new(1, 0, 1, 0)
        TabButtons.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabButtons.ScrollBarThickness = 0

        UIListLayout.Parent = TabButtons
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 5)

        UIPadding.Parent = TabButtons
        UIPadding.PaddingTop = UDim.new(0, 5)

        TabHolder.Name = "TabHolder"
        TabHolder.Parent = MainFrame
        TabHolder.AnchorPoint = Vector2.new(1, 0)
        TabHolder.BackgroundColor3 = UILib.Colors.MainColor2
        TabHolder.BackgroundTransparency = 1.000
        TabHolder.BorderSizePixel = 0
        TabHolder.Position = UDim2.new(1, 0, 0, 0)
        TabHolder.Size = UDim2.new(0.422222227, 130, 1, 0)

        Title.Name = "Title"
        Title.Parent = TopFrame
        Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Title.BackgroundTransparency = 1.000
        Title.Position = UDim2.new(0, 8, 0, 0)
        Title.Size = UDim2.new(0, 150, 1, 0)
        Title.Font = Enum.Font.RobotoMono
        Title.Text = title
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 14.000
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local keybindcon

        local Closed = false;

        local UI_Visible = true;
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == toggleKey and Closed == false then 
                UI_Visible = not UI_Visible
                local Position = UI_Visible and UDim2.new(0.3, 0, 0.3, 0) or UDim2.new(0.5, 0, -1, 0)
                TopFrame:TweenPosition(Position, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
            end
        end)

        local Tabs = {Objects = {}; CurrentTab = nil; Count = 0; Size = {Normal = UDim2.new(1,-20,1,-20); Closed = UDim2.new(1,-20,0,0)}}

        function Tabs:CreateTab(Title)
            Tabs.Count = Tabs.Count + 1
            local Name = tostring(Tabs.Count) .. Title


            local TabButton = Instance.new("TextButton")
            local Holder = Instance.new("ScrollingFrame")
            local UIListLayout = Instance.new("UIListLayout")
            local UIPadding = Instance.new("UIPadding")

            TabButton.Name = Name
            TabButton.Parent = TabButtons
            TabButton.BackgroundColor3 = UILib.Colors.ContrastColor
            TabButton.BorderSizePixel = 0
            TabButton.Size = UDim2.new(1, -10, 0, 25)
            TabButton.AutoButtonColor = false
            TabButton.Font = Enum.Font.RobotoMono
            TabButton.Text = Title
            TabButton.TextColor3 = UILib.Colors.DarkGray
            TabButton.TextSize = 14.000
            TabButton.MouseButton1Click:Connect(function()
                if TabButton.Name ~= Tabs.CurrentTab.Name then
                    TweenService:Create(Tabs.CurrentTab.Button, TweenInfo.new(0.15), {TextColor3 = UILib.Colors.DarkGray}):Play()
                    TweenService:Create(Tabs.CurrentTab.Frame, TweenInfo.new(0.15), {Size = Tabs.Size.Closed}):Play()
                    wait(0.1)
                    Tabs.CurrentTab.Frame.Visible = false;
                    Tabs.CurrentTab = Tabs.Objects[Name]
                    TweenService:Create(Tabs.CurrentTab.Button, TweenInfo.new(0.15), {TextColor3 = UILib.Colors.Gray}):Play()
                    Tabs.CurrentTab.Frame.Visible = true;
                    TweenService:Create(Tabs.CurrentTab.Frame, TweenInfo.new(0.15), {Size = Tabs.Size.Normal}):Play()
                end
            end)

            Holder.Name = "Holder"
            Holder.Parent = TabHolder
            Holder.Active = true
            Holder.Visible = false;
            Holder.AnchorPoint = Vector2.new(0.5, 0.5)
            Holder.BackgroundColor3 = UILib.Colors.MainColor2
            Holder.BorderSizePixel = 0
            Holder.Position = UDim2.new(0.5, 0, 0.5, 0)
            Holder.Size = Tabs.Size.Closed--UDim2.new(1, -20, 1, -20)
            Holder.CanvasSize = UDim2.new(0, 0, 0, 0)
            Holder.ScrollBarThickness = 0

            UIListLayout.Parent = Holder
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 5)

            UIPadding.Parent = Holder
            UIPadding.PaddingTop = UDim.new(0, 5)

            Tabs.Objects[Name] = {
                Frame  = Holder;
                Button = TabButton;
                Name   = Name;
            };

            if Tabs.Count == 1 then 
                for i,v in pairs(Tabs.Objects) do 
                    if tonumber(i:sub(1,1)) == 1 then 
                        Tabs.CurrentTab = v
                        TweenService:Create(Tabs.CurrentTab.Button, TweenInfo.new(0.15), {TextColor3 = UILib.Colors.Gray}):Play()
                        Tabs.CurrentTab.Frame.Visible = true;
                        TweenService:Create(Tabs.CurrentTab.Frame, TweenInfo.new(0.15), {Size = Tabs.Size.Normal}):Play()
                    end
                end
            end
            local Properties = {
                AddSize = {
                    Layout  = UIListLayout.Padding.Offset;
                    Padding = UIPadding.PaddingTop.Offset;
                };
                ItemSize = UDim2.new(1,-10,0,25)
            };
            local function CalculateNewSize(holder)
                local YSize = 0
                for i,v in pairs(holder:GetChildren()) do 
                    if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
                        YSize = (YSize + v.Size.Y.Offset) + Properties.AddSize.Layout
                    end
                end
                YSize = YSize + (Properties.AddSize.Padding)
                return UDim2.new(0,0,0, YSize)
            end


            local function Resize()
                Holder.CanvasSize = CalculateNewSize(Holder)
            end

            local Items  = {}

            function Items:Button(Properties)
                local Callback = Properties.Callback
                local BtnTitle = Properties.Title
                local InfoText = Properties.InfoText


                local Button = Instance.new("Frame")
                local Title = Instance.new("TextLabel")
                local Trigger = Instance.new("TextButton")

                Button.Name = "Button"
                Button.Parent = Holder;
                Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Button.BackgroundTransparency = 1.000
                Button.BorderSizePixel = 0
                Button.Size = UDim2.new(1, -10, 0, 25)

                Title.Name = "Title"
                Title.Parent = Button
                Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Title.BackgroundTransparency = 1.000
                Title.Position = UDim2.new(0, 8, 0, 0)
                Title.Size = UDim2.new(0, 177, 1, 0)
                Title.ZIndex = 2
                Title.Font = Enum.Font.RobotoMono
                Title.Text = BtnTitle
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextSize = 14.000
                Title.TextWrapped = true;
                Title.TextXAlignment = Enum.TextXAlignment.Left

                Trigger.Name = "Trigger"
                Trigger.Parent = Button
                Trigger.AnchorPoint = Vector2.new(1, 1)
                Trigger.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                Trigger.BorderSizePixel = 0
                Trigger.ClipsDescendants = true
                Trigger.Position = UDim2.new(1, 0, 1, 0)
                Trigger.Size = UDim2.new(0, 100, 0, 25)
                Trigger.AutoButtonColor = false
                Trigger.Font = Enum.Font.Code
                Trigger.Text = ""
                Trigger.TextColor3 = Color3.fromRGB(235, 235, 235)
                Trigger.TextSize = 14.000

                Ripple(Trigger)

                Trigger.MouseButton1Click:Connect(function()
                    Callback()
                end)
                UILib:AddInfo(Button, {Text = InfoText}, UI)
                Resize()
            end

            function Items:Dropdown(Properties)
                local Items    = Properties.Items
                local BtnTitle = Properties.Title
                local Callback = Properties.Callback
                local InfoText = Properties.InfoText



                local Dropdown = Instance.new("Frame")
                local Title = Instance.new("TextLabel")
                local Trigger = Instance.new("TextButton")
                local FillParent = Instance.new("Frame")
                local Fill = Instance.new("Frame")
                local Background = Instance.new("Frame")

                Dropdown.Name = "Dropdown"
                Dropdown.Parent = Holder
                Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Dropdown.BackgroundTransparency = 1.000
                Dropdown.BorderSizePixel = 0
                Dropdown.Size = UDim2.new(1, -10, 0, 25)

                Title.Name = "Title"
                Title.Parent = Dropdown
                Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Title.BackgroundTransparency = 1.000
                Title.Position = UDim2.new(0, 8, 0, 0)
                Title.Size = UDim2.new(0, 177, 1, 0)
                Title.ZIndex = 2
                Title.Font = Enum.Font.RobotoMono
                Title.Text = BtnTitle
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextSize = 14.000
                Title.TextXAlignment = Enum.TextXAlignment.Left

                Trigger.Name = "Trigger"
                Trigger.Parent = Dropdown
                Trigger.AnchorPoint = Vector2.new(1, 1)
                Trigger.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                Trigger.BorderSizePixel = 0
                Trigger.ClipsDescendants = true
                Trigger.Position = UDim2.new(1, 0, 1, 0)
                Trigger.Size = UDim2.new(0, 100, 0, 25)
                Trigger.AutoButtonColor = false
                Trigger.Font = Enum.Font.Code
                Trigger.Text = ""
                Trigger.TextColor3 = Color3.fromRGB(235, 235, 235)
                Trigger.TextSize = 14.000

                FillParent.Name = "FillParent"
                FillParent.Parent = Trigger
                FillParent.AnchorPoint = Vector2.new(0.5, 0.5)
                FillParent.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                FillParent.BackgroundTransparency = 1.000
                FillParent.BorderSizePixel = 0
                FillParent.ClipsDescendants = true
                FillParent.Position = UDim2.new(0.5, 0, 0.5, 0)
                FillParent.Size = UDim2.new(1, -4, 1, -4)

                Fill.Name = "Fill"
                Fill.Parent = FillParent
                Fill.AnchorPoint = Vector2.new(0, 0.5)
                Fill.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                Fill.BorderSizePixel = 0
                Fill.Position = UDim2.new(0, 0, 0.5, 0)
                Fill.Size = UDim2.new(0, 0, 1, 0)
                Fill.ZIndex = 2

                Background.Name = "Background"
                Background.Parent = Trigger
                Background.AnchorPoint = Vector2.new(0.5, 0.5)
                Background.BackgroundColor3 = Color3.fromRGB(17, 17, 24)
                Background.BorderSizePixel = 0
                Background.Position = UDim2.new(0.5, 0, 0.5, 0)
                Background.Size = UDim2.new(1, -2, 1, -2)

                local Open = Instance.new("BoolValue", Trigger)
                Open.Name = "Open"

                local OnCooldown = false;
                local LoadDropdown = function(items, parent)
                    if OnCooldown then return end
                    OnCooldown = true
                    local ZIndex = 100;

                    local Dropdown = Instance.new("ScreenGui")
                    local TopFrame = Instance.new("Frame")
                    local MainFrame = Instance.new("Frame")
                    local ItemHolder = Instance.new("Frame")
                    local Buttons = Instance.new("ScrollingFrame")
                    local UIListLayout = Instance.new("UIListLayout")
                    local UIPadding = Instance.new("UIPadding")
                    local Title = Instance.new("TextLabel")

                    Dropdown.Name = "Dropdown"
                    Dropdown.Parent = parent
                    Dropdown.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

                    TopFrame.Name = "TopFrame"
                    TopFrame.Parent = Dropdown
                    TopFrame.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                    TopFrame.BorderColor3 = Color3.fromRGB(89, 92, 150)
                    TopFrame.Position = UDim2.new(0, 50, 0, 50)
                    TopFrame.Size = UDim2.new(0, 200, 0, 25)
                    TopFrame.ZIndex = ZIndex;
                    ZIndex = ZIndex + 1
                    Dragger.Add(TopFrame)

                    MainFrame.Name = "MainFrame"
                    MainFrame.Parent = TopFrame
                    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
                    MainFrame.BorderColor3 = Color3.fromRGB(89, 92, 150)
                    MainFrame.Position = UDim2.new(0, 0, 0, 25)
                    MainFrame.Size = UDim2.new(1, 0, 0, 295)
                    MainFrame.ZIndex = ZIndex;
                    ZIndex = ZIndex + 1

                    ItemHolder.Name = "ItemHolder"
                    ItemHolder.Parent = MainFrame
                    ItemHolder.AnchorPoint = Vector2.new(0, 0.5)
                    ItemHolder.BackgroundColor3 = Color3.fromRGB(17, 17, 24)
                    ItemHolder.BorderSizePixel = 0
                    ItemHolder.Position = UDim2.new(0, 10, 0.5, 0)
                    ItemHolder.Size = UDim2.new(1, -20, 1, -20)
                    ItemHolder.ZIndex = ZIndex;
                    ZIndex = ZIndex + 1

                    Buttons.Name = "Buttons"
                    Buttons.Parent = ItemHolder
                    Buttons.Active = true
                    Buttons.AnchorPoint = Vector2.new(1, 1)
                    Buttons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Buttons.BackgroundTransparency = 1.000
                    Buttons.Position = UDim2.new(1, 0, 1, 0)
                    Buttons.Size = UDim2.new(1, 0, 1, 0)
                    Buttons.CanvasSize = UDim2.new(0, 0, 0, 0)
                    Buttons.ScrollBarThickness = 0
                    Buttons.ZIndex = ZIndex;
                    ZIndex = ZIndex + 1

                    UIListLayout.Parent = Buttons
                    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    UIListLayout.Padding = UDim.new(0, 5)

                    UIPadding.Parent = Buttons
                    UIPadding.PaddingTop = UDim.new(0, 5)

                    Title.Name = "Title"
                    Title.Parent = TopFrame
                    Title.AnchorPoint = Vector2.new(1, 1)
                    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Title.BackgroundTransparency = 1.000
                    Title.Position = UDim2.new(1, 0, 1, 0)
                    Title.Size = UDim2.new(1, 0, 1, 0)
                    Title.Font = Enum.Font.RobotoMono
                    Title.Text = "Dropdown"
                    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Title.TextSize = 14.000
                    Title.ZIndex = ZIndex;
                    ZIndex = ZIndex + 1

                    for i,v in pairs(MainFrame:GetDescendants()) do 
                        if CheckForProperty(v, "BackgroundTransparency") then 
                            v.BackgroundTransparency = 1
                        end
                        if CheckForProperty(v, "BorderSizePixel") then 
                            v.BorderSizePixel = 0
                        end
                        if CheckForProperty(v, "TextTransparency") then 
                            v.TextTransparency = 1
                        end
                        if CheckForProperty(v, "ImageTransparency") then 
                            v.ImageTransparency = 1
                        end
                    end
                    MainFrame.Size = UDim2.new(1,0,0,0)
                    Title.TextTransparency = 1
                    TopFrame.Size = UDim2.new(0,200,0,0)



                    local UISB = nil
                    local function CloseAnim()
                        Open.Value = false;
                        Trigger.FillParent.Fill:TweenSize((Open.Value and UDim2.new(1,0,1,0) or UDim2.new(0,0,1,0)), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad,0.2, false);
                        UISB:Disconnect()
                        for i,v in pairs(MainFrame:GetDescendants()) do 
                            if CheckForProperty(v, "BorderSizePixel") and v.Name ~= "Item" and v.Name ~= "ItemHolder" then 
                                v.BorderSizePixel = 0
                            end
                        end
                        for i,v in pairs(MainFrame:GetDescendants()) do 
                            if CheckForProperty(v, "BackgroundTransparency") then 
                                TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                            end
                            if CheckForProperty(v, "TextTransparency") then 
                                TweenService:Create(v, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
                            end
                            if CheckForProperty(v, "ImageTransparency") then 
                                TweenService:Create(v, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                            end
                        end
                        MainFrame:TweenSize(UDim2.new(1,0,0,0),Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
                        TweenService:Create(Title, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
                        wait(0.1)
                        TopFrame:TweenSize(UDim2.new(0,200,0,0),Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
                        wait(0.2)
                        Dropdown:Destroy()
                        wait(0.3)
                        OnCooldown = false;
                    end

                    local function OpenAnim()
                        OnCooldown = true;
                        Open.Value = true;
                        Trigger.FillParent.Fill:TweenSize((Open.Value and UDim2.new(1,0,1,0) or UDim2.new(0,0,1,0)), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad,0.2, false);

                        TopFrame:TweenSize(UDim2.new(0,200,0,25),Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
                        wait(0.1)
                        TweenService:Create(Title, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
                        MainFrame:TweenSize(UDim2.new(1,0,0,295),Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)

                        for i,v in pairs(MainFrame:GetDescendants()) do 
                            if CheckForProperty(v, "BackgroundTransparency") and v.Name ~= "Buttons" then 
                                TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
                            end
                            if CheckForProperty(v, "TextTransparency") then 
                                TweenService:Create(v, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
                            end
                            if CheckForProperty(v, "ImageTransparency") then 
                                TweenService:Create(v, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
                            end
                        end

                        for i,v in pairs(MainFrame:GetDescendants()) do 
                            if CheckForProperty(v, "BorderSizePixel") and v.Name ~= "Item" and v.Name ~= "ItemHolder" then 
                                v.BorderSizePixel = 1
                            end
                        end
                    end

                    local oldCanvas = Buttons.CanvasSize
                    for i,v in pairs(items) do 
                        oldCanvas = oldCanvas + UDim2.new(0,0,0,30) 
                        Buttons.CanvasSize = oldCanvas;
                        local itemTxt = (typeof(v) == "string" and v) or (i)

                        local Item = Instance.new("TextButton")
                        Item.Name = "Item"
                        Item.Parent = Buttons
                        Item.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                        Item.BorderSizePixel = 0
                        Item.Size = UDim2.new(1, -10, 0, 25)
                        Item.AutoButtonColor = false
                        Item.Font = Enum.Font.RobotoMono
                        Item.Text = itemTxt
                        Item.TextColor3 = Color3.fromRGB(235, 235, 235)
                        Item.TextSize = 14.000
                        Item.ZIndex = ZIndex;
                        Item.MouseButton1Down:Connect(function()
                            Callback(itemTxt)
                            CloseAnim()
                        end)
                        ZIndex = ZIndex + 1
                    end
                    oldCanvas = oldCanvas + UDim2.new(0,0,0,5)
                    Buttons.CanvasSize = oldCanvas;

                    UISB = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 and MouseInFrame(MainFrame) == false and MouseInFrame(TopFrame) == false then 
                            CloseAnim()
                        end
                    end)
                    OpenAnim()
                end

                Trigger.MouseButton1Click:Connect(function()
                    if OnCooldown then return end
                    LoadDropdown(Items, UI)
                end)
                UILib:AddInfo(Dropdown, {Text = InfoText}, UI)
                Resize()
            end

            function Items:Keybind(Properties)
                local keyboardOnly = Properties.KeyboardOnly
                local BtnTitle     = Properties.Title
                local InfoText     = Properties.InfoText
                local Callback     = Properties.Callback
                local Default      = Properties.Default
                local AddToggle    = Properties.Toggleable

                local flag
                local ToggleTrigger = Instance.new("TextButton")
                local Togglef
                if AddToggle then 
                    local Fill = Instance.new("Frame")
                    local FillFrame = Instance.new("Frame")
    
                    ToggleTrigger.Name = "Trigger"
                    ToggleTrigger.AnchorPoint = Vector2.new(1, 1)
                    ToggleTrigger.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                    ToggleTrigger.BorderSizePixel = 0
                    ToggleTrigger.Position = UDim2.new(1, 0, 1, 0)
                    ToggleTrigger.Size = UDim2.new(0, 25, 0, 25)
                    ToggleTrigger.AutoButtonColor = false
                    ToggleTrigger.Font = Enum.Font.Code
                    ToggleTrigger.Text = ""
                    ToggleTrigger.TextColor3 = Color3.fromRGB(235, 235, 235)
                    ToggleTrigger.TextSize = 14.000
    
                    Fill.Name = "Fill"
                    Fill.Parent = ToggleTrigger
                    Fill.AnchorPoint = Vector2.new(0.5, 0.5)
                    Fill.BackgroundColor3 = Color3.fromRGB(17, 17, 24)
                    Fill.BorderSizePixel = 0
                    Fill.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Fill.Size = UDim2.new(1, -2, 1, -2)
    
                    FillFrame.Name = "FillFrame"
                    FillFrame.Parent = ToggleTrigger
                    FillFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                    FillFrame.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                    FillFrame.BorderSizePixel = 0
                    FillFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                    FillFrame.Size = UDim2.new(1, -4, 1, -4)
    
                    local Toggled = Default;
    
                    Togglef = function(value, trigger)
                        if value ~= nil then Toggled = value else Toggled = not Toggled end
                        if trigger then
                            KeyBinds[flag].toggled.toggled = Toggled
                        end
    
                        local Size = Toggled and UDim2.new(1,-4,1,-4) or UDim2.new(0,0,0,0)
                        ToggleTrigger.FillFrame:TweenSize(Size,Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.1, true)
                    end
    
                    ToggleTrigger.MouseButton1Click:Connect(function()
                        Togglef(nil, true)
                    end)
                end

                local Keybind = Instance.new("Frame")
                flag = Keybind
                local Title = Instance.new("TextLabel")
                local Trigger = Instance.new("TextButton")

                Keybind.Name = "Keybind"
                Keybind.Parent = Holder
                Keybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Keybind.BackgroundTransparency = 1.000
                Keybind.BorderSizePixel = 0
                Keybind.Size = UDim2.new(1, -10, 0, 25)

                Title.Name = "Title"
                Title.Parent = Keybind
                Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Title.BackgroundTransparency = 1.000
                Title.Position = UDim2.new(0, 8, 0, 0)
                Title.Size = UDim2.new(0, 177, 1, 0)
                Title.ZIndex = 2
                Title.Font = Enum.Font.RobotoMono
                Title.Text = BtnTitle
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextSize = 14.000
                Title.TextXAlignment = Enum.TextXAlignment.Left

                Trigger.Name = "Trigger"
                Trigger.Parent = Keybind
                Trigger.AnchorPoint = Vector2.new(1, 1)
                Trigger.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                Trigger.BorderSizePixel = 0
                Trigger.ClipsDescendants = true
                Trigger.Position = UDim2.new(1, 0, 1, 0)
                Trigger.Size = UDim2.new(0, 100, 0, 25)
                Trigger.AutoButtonColor = false
                Trigger.Font = Enum.Font.Code
                Trigger.Text = ""
                Trigger.TextColor3 = Color3.fromRGB(235, 235, 235)
                Trigger.TextSize = 14

                ToggleTrigger.Parent = Keybind
                ToggleTrigger.Position = UDim2.new(1,-105, 1, 0)
                Togglef(false, false)

                local location = {}
                location[flag]  = Default
                Trigger.MouseButton1Click:Connect(function()
                    Trigger.Text = "..."
                    local a, b = UserInputService.InputBegan:wait();
                    local name = tostring(a.KeyCode.Name);
                    local typeName = tostring(a.UserInputType.Name);

                    if (a.UserInputType ~= Enum.UserInputType.Keyboard and (allowed[a.UserInputType.Name]) and (not keyboardOnly)) or (a.KeyCode and (not banned[a.KeyCode.Name])) then
                        local name = (a.UserInputType ~= Enum.UserInputType.Keyboard and a.UserInputType.Name or a.KeyCode.Name);
                        location[flag] = (a);
                        if not shortNames[name] and name:find("Enum.KeyCode.") then 
                            name = tostring(name):sub(14, #tostring(name))
                        end
                        Trigger.Text = shortNames[name] or tostring(name);

                    else
                        if (location[flag]) then
                            if (not pcall(function()
                                    return location[flag].UserInputType
                                end)) then
                                local name = tostring(location[flag])
                                if not shortNames[name] and name:find("Enum.KeyCode.") then 
                                    name = tostring(name):sub(14, #tostring(name))
                                end
                                Trigger.Text = shortNames[name] or tostring(name)
                            else
                                local name = (location[flag].UserInputType ~= Enum.UserInputType.Keyboard and location[flag].UserInputType.Name or location[flag].KeyCode.Name);
                                if not shortNames[name] and name:find("Enum.KeyCode.") then 
                                    name = tostring(name):sub(14, #tostring(name))
                                end
                                Trigger.Text = shortNames[name] or tostring(name);
                            end
                        end
                    end
                    wait(0.1)  
                    isBinding = false;
                end)

                if location[flag] then
                    Trigger.Text = shortNames[tostring(location[flag].Name)] or tostring(location[flag].Name)
                end

                KeyBinds[flag] = {
                    location = location;
                    toggled  = {
                        needed  = AddToggle;
                        toggled = false;
                    };
                    callback = Callback;
                };

                UILib:AddInfo(Keybind, {Text = InfoText}, UI)
                Resize()
            end

            function Items:Slider(Properties)
                local Callback = Properties.Callback
                local BtnTitle = Properties.Title
                local InfoText = Properties.InfoText


                local Slider = Instance.new("Frame")
                local Title = Instance.new("TextLabel")
                local Trigger = Instance.new("TextButton")
                local Background = Instance.new("Frame")
                local Value = Instance.new("TextLabel")
                local FillParent = Instance.new("Frame")
                local Fill = Instance.new("Frame")

                Slider.Name = "Slider"
                Slider.Parent = Holder
                Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Slider.BackgroundTransparency = 1.000
                Slider.BorderSizePixel = 0
                Slider.Size = UDim2.new(1, -10, 0, 25)

                Title.Name = "Title"
                Title.Parent = Slider
                Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Title.BackgroundTransparency = 1.000
                Title.Position = UDim2.new(0, 8, 0, 0)
                Title.Size = UDim2.new(0, 177, 1, 0)
                Title.Font = Enum.Font.RobotoMono
                Title.Text = BtnTitle
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextSize = 14.000
                Title.TextXAlignment = Enum.TextXAlignment.Left

                Trigger.Name = "Trigger"
                Trigger.Parent = Slider
                Trigger.AnchorPoint = Vector2.new(1, 1)
                Trigger.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                Trigger.BorderSizePixel = 0
                Trigger.Position = UDim2.new(1, 0, 1, 0)
                Trigger.Size = UDim2.new(0, 100, 0, 25)
                Trigger.AutoButtonColor = false
                Trigger.Font = Enum.Font.Code
                Trigger.Text = ""
                Trigger.TextColor3 = Color3.fromRGB(235, 235, 235)
                Trigger.TextSize = 14.000

                Background.Name = "Background"
                Background.Parent = Trigger
                Background.AnchorPoint = Vector2.new(0.5, 0.5)
                Background.BackgroundColor3 = Color3.fromRGB(17, 17, 24)
                Background.BorderSizePixel = 0
                Background.Position = UDim2.new(0.5, 0, 0.5, 0)
                Background.Size = UDim2.new(1, -2, 1, -2)

                Value.Name = "Value"
                Value.Parent = Trigger
                Value.AnchorPoint = Vector2.new(1, 1)
                Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Value.BackgroundTransparency = 1.000
                Value.Position = UDim2.new(1, 0, 1, 0)
                Value.Size = UDim2.new(1, 0, 1, 0)
                Value.ZIndex = 5
                Value.Font = Enum.Font.RobotoMono
                Value.Text = "0"
                Value.TextColor3 = Color3.fromRGB(255, 255, 255)
                Value.TextSize = 14.000

                FillParent.Name = "FillParent"
                FillParent.Parent = Trigger
                FillParent.AnchorPoint = Vector2.new(0.5, 0.5)
                FillParent.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                FillParent.BackgroundTransparency = 1.000
                FillParent.BorderSizePixel = 0
                FillParent.ClipsDescendants = true
                FillParent.Position = UDim2.new(0.5, 0, 0.5, 0)
                FillParent.Size = UDim2.new(1, -4, 1, -4)

                Fill.Name = "Fill"
                Fill.Parent = FillParent
                Fill.AnchorPoint = Vector2.new(0, 0.5)
                Fill.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                Fill.BorderSizePixel = 0
                Fill.Position = UDim2.new(0, 0, 0.5, 0)
                Fill.Size = UDim2.new(0, 0, 1, 0)


                local Connection;
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if(Connection) then
                            Connection:Disconnect();
                            Connection = nil;
                        end;
                    end;
                end);

                Trigger.MouseButton1Down:Connect(function()
                    if(Connection) then
                        Connection:Disconnect();
                    end;

                    Connection = RunService.Heartbeat:Connect(function()
                        local mousel = UserInputService:GetMouseLocation();
                        local percent = math.clamp((mousel.X - Trigger.AbsolutePosition.X) / (Trigger.AbsoluteSize.X), 0, 1);
                        local Value = Properties.Min + (Properties.Max - Properties.Min) * percent;

                        if not Properties.precise then
                            Value = math.floor(Value)
                        end

                        Value = tonumber(string.format("%.2f", Value));


                        TweenService:Create(Trigger.FillParent.Fill, TweenInfo.new(0.01), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
                        Trigger.Value.Text = tostring(Value);

                        Callback(Value);
                    end);
                end);
                Trigger.Value.Text = tostring(Properties.Min);


                UILib:AddInfo(Slider, {Text = InfoText}, UI)
                Resize()
            end

            function Items:Toggle(Properties)
                local Callback = Properties.Callback
                local BtnTitle = Properties.Title
                local InfoText = Properties.InfoText
                local Default  = Properties.Default

                local Toggle = Instance.new("Frame")
                local Trigger = Instance.new("TextButton")
                local Fill = Instance.new("Frame")
                local FillFrame = Instance.new("Frame")
                local Title = Instance.new("TextLabel")

                Toggle.Name = "Toggle"
                Toggle.Parent = Holder
                Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Toggle.BackgroundTransparency = 1.000
                Toggle.BorderSizePixel = 0
                Toggle.Size = UDim2.new(1, -10, 0, 25)

                Trigger.Name = "Trigger"
                Trigger.Parent = Toggle
                Trigger.AnchorPoint = Vector2.new(1, 1)
                Trigger.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                Trigger.BorderSizePixel = 0
                Trigger.Position = UDim2.new(1, 0, 1, 0)
                Trigger.Size = UDim2.new(0, 25, 0, 25)
                Trigger.AutoButtonColor = false
                Trigger.Font = Enum.Font.Code
                Trigger.Text = ""
                Trigger.TextColor3 = Color3.fromRGB(235, 235, 235)
                Trigger.TextSize = 14.000

                Fill.Name = "Fill"
                Fill.Parent = Trigger
                Fill.AnchorPoint = Vector2.new(0.5, 0.5)
                Fill.BackgroundColor3 = Color3.fromRGB(17, 17, 24)
                Fill.BorderSizePixel = 0
                Fill.Position = UDim2.new(0.5, 0, 0.5, 0)
                Fill.Size = UDim2.new(1, -2, 1, -2)

                FillFrame.Name = "FillFrame"
                FillFrame.Parent = Trigger
                FillFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                FillFrame.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                FillFrame.BorderSizePixel = 0
                FillFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                FillFrame.Size = UDim2.new(1, -4, 1, -4)

                Title.Name = "Title"
                Title.Parent = Toggle
                Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Title.BackgroundTransparency = 1.000
                Title.Position = UDim2.new(0, 8, 0, 0)
                Title.Size = UDim2.new(0, 252, 1, 0)
                Title.Font = Enum.Font.RobotoMono
                Title.Text = BtnTitle
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextSize = 14.000
                Title.TextXAlignment = Enum.TextXAlignment.Left


                local Toggled = Default;

                local function Togglef(value, callback)
                    if value ~= nil then Toggled = value else Toggled = not Toggled end
                    if callback then Callback(Toggled) end

                    local Size = Toggled and UDim2.new(1,-4,1,-4) or UDim2.new(0,0,0,0)
                    Trigger.FillFrame:TweenSize(Size,Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.1, true)
                end

                Trigger.MouseButton1Click:Connect(function()
                    Togglef(nil, true)
                end)

                Togglef(Toggled, false)
                UILib:AddInfo(Toggle, {Text = InfoText}, UI)
                Resize()
            end

            function Items:Section(SectionTitle)
                local Section = Instance.new("Frame")
                local Trigger = Instance.new("TextButton")
                local Section_Holder = Instance.new("ScrollingFrame")
                local UIListLayout = Instance.new("UIListLayout")
                local UIPadding = Instance.new("UIPadding")

                Section.Name = "Section"
                Section.Parent = Holder
                Section.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
                Section.BorderSizePixel = 0
                Section.LayoutOrder = -1
                Section.Position = UDim2.new(0.0166666675, 0, 0.0181818176, 0)
                Section.Size = UDim2.new(1, -10, 0, 25)

                Trigger.Name = "Trigger"
                Trigger.Parent = Section
                Trigger.AnchorPoint = Vector2.new(0.5, 0)
                Trigger.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                Trigger.BorderSizePixel = 0
                Trigger.Position = UDim2.new(0.5, 0, 0, 0)
                Trigger.Size = UDim2.new(1, 0, 0, 25)
                Trigger.AutoButtonColor = false
                Trigger.Font = Enum.Font.RobotoMono
                Trigger.Text = SectionTitle
                Trigger.TextColor3 = Color3.fromRGB(235, 235, 235)
                Trigger.TextSize = 14.000

                Section_Holder.Name = "Holder"
                Section_Holder.Parent = Section
                Section_Holder.Active = true
                Section_Holder.AnchorPoint = Vector2.new(1, 1)
                Section_Holder.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
                Section_Holder.BorderSizePixel = 0
                Section_Holder.Position = UDim2.new(1, 0, 1, 0)
                Section_Holder.Size = UDim2.new(1, 0, 1, -25)
                Section_Holder.CanvasSize = UDim2.new(0, 0, 0, 0)
                Section_Holder.ScrollBarThickness = 0

                UIListLayout.Parent = Section_Holder
                UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Padding = UDim.new(0, 5)

                UIPadding.Parent = Section_Holder
                UIPadding.PaddingTop = UDim.new(0, 5)

                local Properties = {
                    MinSize = UDim2.new(1,-10,0,25);
                    AddSize = {
                        Layout  = UIListLayout.Padding.Offset;
                        Padding = UIPadding.PaddingTop.Offset;
                    };
                    Paddings = 2;
                    ItemSize = UDim2.new(1,-10,0,25)
                };


                local function GetSize(holder)
                    local YSize = 0
                    for i,v in pairs(holder:GetChildren()) do 
                        if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
                            YSize = (YSize + v.Size.Y.Offset) + Properties.AddSize.Layout
                        end
                    end
                    YSize = YSize + (Properties.AddSize.Padding)
                    return UDim2.new(0,0,0, YSize)
                end

                local SectionOpen = false;

                Trigger.MouseButton1Click:Connect(function()
                    SectionOpen = not SectionOpen;
                    local YSize = (SectionOpen and ((#Section_Holder:GetChildren() - Properties.Paddings) * (Properties.ItemSize.Y.Offset + Properties.AddSize.Layout)) + (Properties.AddSize.Layout + Properties.MinSize.Y.Offset)) or (Properties.MinSize.Y.Offset)
                    local Size = UDim2.new(1,-10,0,YSize)

                    Section:TweenSize(Size,Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, false)
                    wait(0.2)
                    Section_Holder.CanvasSize = GetSize(Section_Holder)
                    Resize()
                end)
                Resize()

                local Items = {}

                function Items:Button(Properties)
                    local Callback = Properties.Callback
                    local BtnTitle = Properties.Title
                    local InfoText = Properties.InfoText


                    local Button = Instance.new("Frame")
                    local Title = Instance.new("TextLabel")
                    local Trigger = Instance.new("TextButton")

                    Button.Name = "Button"
                    Button.Parent = Section_Holder;
                    Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Button.BackgroundTransparency = 1.000
                    Button.BorderSizePixel = 0
                    Button.Size = UDim2.new(1, -10, 0, 25)

                    Title.Name = "Title"
                    Title.Parent = Button
                    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Title.BackgroundTransparency = 1.000
                    Title.Position = UDim2.new(0, 8, 0, 0)
                    Title.Size = UDim2.new(0, 177, 1, 0)
                    Title.ZIndex = 2
                    Title.Font = Enum.Font.RobotoMono
                    Title.Text = BtnTitle
                    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Title.TextSize = 14.000
                    Title.TextWrapped = true;
                    Title.TextXAlignment = Enum.TextXAlignment.Left

                    Trigger.Name = "Trigger"
                    Trigger.Parent = Button
                    Trigger.AnchorPoint = Vector2.new(1, 1)
                    Trigger.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                    Trigger.BorderSizePixel = 0
                    Trigger.ClipsDescendants = true
                    Trigger.Position = UDim2.new(1, 0, 1, 0)
                    Trigger.Size = UDim2.new(0, 100, 0, 25)
                    Trigger.AutoButtonColor = false
                    Trigger.Font = Enum.Font.Code
                    Trigger.Text = ""
                    Trigger.TextColor3 = Color3.fromRGB(235, 235, 235)
                    Trigger.TextSize = 14.000

                    Ripple(Trigger)

                    Trigger.MouseButton1Click:Connect(function()
                        Callback()
                    end)
                    UILib:AddInfo(Button, {Text = InfoText}, UI)

                end

                function Items:Dropdown(Properties)
                    local Items    = Properties.Items
                    local BtnTitle = Properties.Title
                    local Callback = Properties.Callback
                    local InfoText = Properties.InfoText



                    local Dropdown = Instance.new("Frame")
                    local Title = Instance.new("TextLabel")
                    local Trigger = Instance.new("TextButton")
                    local FillParent = Instance.new("Frame")
                    local Fill = Instance.new("Frame")
                    local Background = Instance.new("Frame")

                    Dropdown.Name = "Dropdown"
                    Dropdown.Parent = Section_Holder
                    Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Dropdown.BackgroundTransparency = 1.000
                    Dropdown.BorderSizePixel = 0
                    Dropdown.Size = UDim2.new(1, -10, 0, 25)

                    Title.Name = "Title"
                    Title.Parent = Dropdown
                    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Title.BackgroundTransparency = 1.000
                    Title.Position = UDim2.new(0, 8, 0, 0)
                    Title.Size = UDim2.new(0, 177, 1, 0)
                    Title.ZIndex = 2
                    Title.Font = Enum.Font.RobotoMono
                    Title.Text = BtnTitle
                    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Title.TextSize = 14.000
                    Title.TextXAlignment = Enum.TextXAlignment.Left

                    Trigger.Name = "Trigger"
                    Trigger.Parent = Dropdown
                    Trigger.AnchorPoint = Vector2.new(1, 1)
                    Trigger.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                    Trigger.BorderSizePixel = 0
                    Trigger.ClipsDescendants = true
                    Trigger.Position = UDim2.new(1, 0, 1, 0)
                    Trigger.Size = UDim2.new(0, 100, 0, 25)
                    Trigger.AutoButtonColor = false
                    Trigger.Font = Enum.Font.Code
                    Trigger.Text = ""
                    Trigger.TextColor3 = Color3.fromRGB(235, 235, 235)
                    Trigger.TextSize = 14.000

                    FillParent.Name = "FillParent"
                    FillParent.Parent = Trigger
                    FillParent.AnchorPoint = Vector2.new(0.5, 0.5)
                    FillParent.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                    FillParent.BackgroundTransparency = 1.000
                    FillParent.BorderSizePixel = 0
                    FillParent.ClipsDescendants = true
                    FillParent.Position = UDim2.new(0.5, 0, 0.5, 0)
                    FillParent.Size = UDim2.new(1, -4, 1, -4)

                    Fill.Name = "Fill"
                    Fill.Parent = FillParent
                    Fill.AnchorPoint = Vector2.new(0, 0.5)
                    Fill.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                    Fill.BorderSizePixel = 0
                    Fill.Position = UDim2.new(0, 0, 0.5, 0)
                    Fill.Size = UDim2.new(0, 0, 1, 0)
                    Fill.ZIndex = 2

                    Background.Name = "Background"
                    Background.Parent = Trigger
                    Background.AnchorPoint = Vector2.new(0.5, 0.5)
                    Background.BackgroundColor3 = Color3.fromRGB(17, 17, 24)
                    Background.BorderSizePixel = 0
                    Background.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Background.Size = UDim2.new(1, -2, 1, -2)

                    local Open = Instance.new("BoolValue", Trigger)
                    Open.Name = "Open"

                    local OnCooldown = false;
                    local LoadDropdown = function(items, parent)
                        if OnCooldown then return end
                        OnCooldown = true
                        local ZIndex = 100;

                        local Dropdown = Instance.new("ScreenGui")
                        local TopFrame = Instance.new("Frame")
                        local MainFrame = Instance.new("Frame")
                        local ItemHolder = Instance.new("Frame")
                        local Buttons = Instance.new("ScrollingFrame")
                        local UIListLayout = Instance.new("UIListLayout")
                        local UIPadding = Instance.new("UIPadding")
                        local Title = Instance.new("TextLabel")

                        Dropdown.Name = "Dropdown"
                        Dropdown.Parent = parent
                        Dropdown.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

                        TopFrame.Name = "TopFrame"
                        TopFrame.Parent = Dropdown
                        TopFrame.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                        TopFrame.BorderColor3 = Color3.fromRGB(89, 92, 150)
                        TopFrame.Position = UDim2.new(0, 50, 0, 50)
                        TopFrame.Size = UDim2.new(0, 200, 0, 25)
                        TopFrame.ZIndex = ZIndex;
                        ZIndex = ZIndex + 1
                        Dragger.Add(TopFrame)

                        MainFrame.Name = "MainFrame"
                        MainFrame.Parent = TopFrame
                        MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
                        MainFrame.BorderColor3 = Color3.fromRGB(89, 92, 150)
                        MainFrame.Position = UDim2.new(0, 0, 0, 25)
                        MainFrame.Size = UDim2.new(1, 0, 0, 295)
                        MainFrame.ZIndex = ZIndex;
                        ZIndex = ZIndex + 1

                        ItemHolder.Name = "ItemHolder"
                        ItemHolder.Parent = MainFrame
                        ItemHolder.AnchorPoint = Vector2.new(0, 0.5)
                        ItemHolder.BackgroundColor3 = Color3.fromRGB(17, 17, 24)
                        ItemHolder.BorderSizePixel = 0
                        ItemHolder.Position = UDim2.new(0, 10, 0.5, 0)
                        ItemHolder.Size = UDim2.new(1, -20, 1, -20)
                        ItemHolder.ZIndex = ZIndex;
                        ZIndex = ZIndex + 1

                        Buttons.Name = "Buttons"
                        Buttons.Parent = ItemHolder
                        Buttons.Active = true
                        Buttons.AnchorPoint = Vector2.new(1, 1)
                        Buttons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        Buttons.BackgroundTransparency = 1.000
                        Buttons.Position = UDim2.new(1, 0, 1, 0)
                        Buttons.Size = UDim2.new(1, 0, 1, 0)
                        Buttons.CanvasSize = UDim2.new(0, 0, 0, 0)
                        Buttons.ScrollBarThickness = 0
                        Buttons.ZIndex = ZIndex;
                        ZIndex = ZIndex + 1

                        UIListLayout.Parent = Buttons
                        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                        UIListLayout.Padding = UDim.new(0, 5)

                        UIPadding.Parent = Buttons
                        UIPadding.PaddingTop = UDim.new(0, 5)

                        Title.Name = "Title"
                        Title.Parent = TopFrame
                        Title.AnchorPoint = Vector2.new(1, 1)
                        Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        Title.BackgroundTransparency = 1.000
                        Title.Position = UDim2.new(1, 0, 1, 0)
                        Title.Size = UDim2.new(1, 0, 1, 0)
                        Title.Font = Enum.Font.RobotoMono
                        Title.Text = "Dropdown"
                        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                        Title.TextSize = 14.000
                        Title.ZIndex = ZIndex;
                        ZIndex = ZIndex + 1

                        for i,v in pairs(MainFrame:GetDescendants()) do 
                            if CheckForProperty(v, "BackgroundTransparency") then 
                                v.BackgroundTransparency = 1
                            end
                            if CheckForProperty(v, "BorderSizePixel") then 
                                v.BorderSizePixel = 0
                            end
                            if CheckForProperty(v, "TextTransparency") then 
                                v.TextTransparency = 1
                            end
                            if CheckForProperty(v, "ImageTransparency") then 
                                v.ImageTransparency = 1
                            end
                        end
                        MainFrame.Size = UDim2.new(1,0,0,0)
                        Title.TextTransparency = 1
                        TopFrame.Size = UDim2.new(0,200,0,0)



                        local UISB = nil
                        local function CloseAnim()
                            Open.Value = false;
                            Trigger.FillParent.Fill:TweenSize((Open.Value and UDim2.new(1,0,1,0) or UDim2.new(0,0,1,0)), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad,0.2, false);
                            UISB:Disconnect()
                            for i,v in pairs(MainFrame:GetDescendants()) do 
                                if CheckForProperty(v, "BorderSizePixel") and v.Name ~= "Item" and v.Name ~= "ItemHolder" then 
                                    v.BorderSizePixel = 0
                                end
                            end
                            for i,v in pairs(MainFrame:GetDescendants()) do 
                                if CheckForProperty(v, "BackgroundTransparency") then 
                                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                                end
                                if CheckForProperty(v, "TextTransparency") then 
                                    TweenService:Create(v, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
                                end
                                if CheckForProperty(v, "ImageTransparency") then 
                                    TweenService:Create(v, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                                end
                            end
                            MainFrame:TweenSize(UDim2.new(1,0,0,0),Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
                            TweenService:Create(Title, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
                            wait(0.1)
                            TopFrame:TweenSize(UDim2.new(0,200,0,0),Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
                            wait(0.2)
                            Dropdown:Destroy()
                            wait(0.3)
                            OnCooldown = false;
                        end

                        local function OpenAnim()
                            OnCooldown = true;
                            Open.Value = true;
                            Trigger.FillParent.Fill:TweenSize((Open.Value and UDim2.new(1,0,1,0) or UDim2.new(0,0,1,0)), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad,0.2, false);

                            TopFrame:TweenSize(UDim2.new(0,200,0,25),Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
                            wait(0.1)
                            TweenService:Create(Title, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
                            MainFrame:TweenSize(UDim2.new(1,0,0,295),Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)

                            for i,v in pairs(MainFrame:GetDescendants()) do 
                                if CheckForProperty(v, "BackgroundTransparency") and v.Name ~= "Buttons" then 
                                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
                                end
                                if CheckForProperty(v, "TextTransparency") then 
                                    TweenService:Create(v, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
                                end
                                if CheckForProperty(v, "ImageTransparency") then 
                                    TweenService:Create(v, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
                                end
                            end

                            for i,v in pairs(MainFrame:GetDescendants()) do 
                                if CheckForProperty(v, "BorderSizePixel") and v.Name ~= "Item" and v.Name ~= "ItemHolder" then 
                                    v.BorderSizePixel = 1
                                end
                            end
                        end

                        local oldCanvas = Buttons.CanvasSize
                        for i,v in pairs(items) do 
                            oldCanvas = oldCanvas + UDim2.new(0,0,0,30)
                            Buttons.CanvasSize = oldCanvas;
                            local itemTxt = (typeof(v) == "string" and v) or (i)

                            local Item = Instance.new("TextButton")
                            Item.Name = "Item"
                            Item.Parent = Buttons
                            Item.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                            Item.BorderSizePixel = 0
                            Item.Size = UDim2.new(1, -10, 0, 25)
                            Item.AutoButtonColor = false
                            Item.Font = Enum.Font.RobotoMono
                            Item.Text = itemTxt
                            Item.TextColor3 = Color3.fromRGB(235, 235, 235)
                            Item.TextSize = 14.000
                            Item.ZIndex = ZIndex;
                            Item.MouseButton1Down:Connect(function()
                                Callback(itemTxt)
                                CloseAnim()
                            end)
                            ZIndex = ZIndex + 1
                        end
                        oldCanvas = oldCanvas + UDim2.new(0,0,0,5)
                        Buttons.CanvasSize = oldCanvas;

                        UISB = UserInputService.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 and MouseInFrame(MainFrame) == false and MouseInFrame(TopFrame) == false then 
                                CloseAnim()
                            end
                        end)
                        OpenAnim()
                    end

                    Trigger.MouseButton1Click:Connect(function()
                        if OnCooldown then return end
                        LoadDropdown(Items, UI)
                    end)
                    UILib:AddInfo(Dropdown, {Text = InfoText}, UI)

                end

                function Items:Keybind(Properties)
                    local keyboardOnly = Properties.KeyboardOnly
                    local BtnTitle     = Properties.Title
                    local InfoText     = Properties.InfoText
                    local Callback     = Properties.Callback
                    local Default      = Properties.Default
                    local AddToggle    = Properties.Toggleable
        
                    local flag

                    local ToggleTrigger = Instance.new("TextButton")
                    local Togglef
                    if AddToggle then 
                        local Fill = Instance.new("Frame")
                        local FillFrame = Instance.new("Frame")
        
                        ToggleTrigger.Name = "Trigger"
                        ToggleTrigger.AnchorPoint = Vector2.new(1, 1)
                        ToggleTrigger.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                        ToggleTrigger.BorderSizePixel = 0
                        ToggleTrigger.Position = UDim2.new(1, 0, 1, 0)
                        ToggleTrigger.Size = UDim2.new(0, 25, 0, 25)
                        ToggleTrigger.AutoButtonColor = false
                        ToggleTrigger.Font = Enum.Font.Code
                        ToggleTrigger.Text = ""
                        ToggleTrigger.TextColor3 = Color3.fromRGB(235, 235, 235)
                        ToggleTrigger.TextSize = 14.000
        
                        Fill.Name = "Fill"
                        Fill.Parent = ToggleTrigger
                        Fill.AnchorPoint = Vector2.new(0.5, 0.5)
                        Fill.BackgroundColor3 = Color3.fromRGB(17, 17, 24)
                        Fill.BorderSizePixel = 0
                        Fill.Position = UDim2.new(0.5, 0, 0.5, 0)
                        Fill.Size = UDim2.new(1, -2, 1, -2)
        
                        FillFrame.Name = "FillFrame"
                        FillFrame.Parent = ToggleTrigger
                        FillFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                        FillFrame.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                        FillFrame.BorderSizePixel = 0
                        FillFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                        FillFrame.Size = UDim2.new(1, -4, 1, -4)
        
                        local Toggled = Default;
        
                        Togglef = function(value, trigger)
                            if value ~= nil then Toggled = value else Toggled = not Toggled end
                            if trigger then
                                KeyBinds[flag].toggled.toggled = Toggled
                            end
        
                            local Size = Toggled and UDim2.new(1,-4,1,-4) or UDim2.new(0,0,0,0)
                            ToggleTrigger.FillFrame:TweenSize(Size,Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.1, true)
                        end
        
                        ToggleTrigger.MouseButton1Click:Connect(function()
                            Togglef(nil, true)
                        end)
                    end

                    local Keybind = Instance.new("Frame")
                    flag = Keybind
                    local Title = Instance.new("TextLabel")
                    local Trigger = Instance.new("TextButton")

                    Keybind.Name = "Keybind"
                    Keybind.Parent = Section_Holder
                    Keybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Keybind.BackgroundTransparency = 1.000
                    Keybind.BorderSizePixel = 0
                    Keybind.Size = UDim2.new(1, -10, 0, 25)

                    ToggleTrigger.Parent = Keybind
                    ToggleTrigger.Position = UDim2.new(1,-105, 1, 0)
                    Togglef(false, false)

                    Title.Name = "Title"
                    Title.Parent = Keybind
                    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Title.BackgroundTransparency = 1.000
                    Title.Position = UDim2.new(0, 8, 0, 0)
                    Title.Size = UDim2.new(0, 177, 1, 0)
                    Title.ZIndex = 2
                    Title.Font = Enum.Font.RobotoMono
                    Title.Text = BtnTitle
                    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Title.TextSize = 14.000
                    Title.TextXAlignment = Enum.TextXAlignment.Left

                    Trigger.Name = "Trigger"
                    Trigger.Parent = Keybind
                    Trigger.AnchorPoint = Vector2.new(1, 1)
                    Trigger.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                    Trigger.BorderSizePixel = 0
                    Trigger.ClipsDescendants = true
                    Trigger.Position = UDim2.new(1, 0, 1, 0)
                    Trigger.Size = UDim2.new(0, 100, 0, 25)
                    Trigger.AutoButtonColor = false
                    Trigger.Font = Enum.Font.Code
                    Trigger.Text = ""
                    Trigger.TextColor3 = Color3.fromRGB(235, 235, 235)
                    Trigger.TextSize = 14.

                    local location = {}
                    location[flag]  = Default
                    Trigger.MouseButton1Click:Connect(function()
                        Trigger.Text = "..."
                        local a, b = UserInputService.InputBegan:wait();
                        local name = tostring(a.KeyCode.Name);
                        local typeName = tostring(a.UserInputType.Name);

                        if (a.UserInputType ~= Enum.UserInputType.Keyboard and (allowed[a.UserInputType.Name]) and (not keyboardOnly)) or (a.KeyCode and (not banned[a.KeyCode.Name])) then
                            local name = (a.UserInputType ~= Enum.UserInputType.Keyboard and a.UserInputType.Name or a.KeyCode.Name);
                            location[flag] = (a);
                            if not shortNames[name] and name:find("Enum.KeyCode.") then 
                                name = tostring(name):sub(14, #tostring(name))
                            end
                            Trigger.Text = shortNames[name] or tostring(name);

                        else
                            if (location[flag]) then
                                if (not pcall(function()
                                        return location[flag].UserInputType
                                    end)) then
                                    local name = tostring(location[flag])
                                    if not shortNames[name] and name:find("Enum.KeyCode.") then 
                                        name = tostring(name):sub(14, #tostring(name))
                                    end
                                    Trigger.Text = shortNames[name] or tostring(name)
                                else
                                    local name = (location[flag].UserInputType ~= Enum.UserInputType.Keyboard and location[flag].UserInputType.Name or location[flag].KeyCode.Name);
                                    if not shortNames[name] and name:find("Enum.KeyCode.") then 
                                        name = tostring(name):sub(14, #tostring(name))
                                    end
                                    Trigger.Text = shortNames[name] or tostring(name);
                                end
                            end
                        end
                        wait(0.1)  
                        isBinding = false;
                    end)

                    if location[flag] then
                        Trigger.Text = shortNames[tostring(location[flag].Name)] or tostring(location[flag].Name)
                    end

                    KeyBinds[flag] = {
                        location = location;
                        toggled  = {
                            needed  = AddToggle;
                            toggled = false;
                        };
                        callback = Callback;
                    };

                    UILib:AddInfo(Keybind, {Text = InfoText}, UI)
                end

                function Items:Slider(Properties)
                    local Callback = Properties.Callback
                    local BtnTitle = Properties.Title
                    local InfoText = Properties.InfoText


                    local Slider = Instance.new("Frame")
                    local Title = Instance.new("TextLabel")
                    local Trigger = Instance.new("TextButton")
                    local Background = Instance.new("Frame")
                    local Value = Instance.new("TextLabel")
                    local FillParent = Instance.new("Frame")
                    local Fill = Instance.new("Frame")

                    Slider.Name = "Slider"
                    Slider.Parent = Section_Holder
                    Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Slider.BackgroundTransparency = 1.000
                    Slider.BorderSizePixel = 0
                    Slider.Size = UDim2.new(1, -10, 0, 25)

                    Title.Name = "Title"
                    Title.Parent = Slider
                    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Title.BackgroundTransparency = 1.000
                    Title.Position = UDim2.new(0, 8, 0, 0)
                    Title.Size = UDim2.new(0, 177, 1, 0)
                    Title.Font = Enum.Font.RobotoMono
                    Title.Text = BtnTitle
                    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Title.TextSize = 14.000
                    Title.TextXAlignment = Enum.TextXAlignment.Left

                    Trigger.Name = "Trigger"
                    Trigger.Parent = Slider
                    Trigger.AnchorPoint = Vector2.new(1, 1)
                    Trigger.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                    Trigger.BorderSizePixel = 0
                    Trigger.Position = UDim2.new(1, 0, 1, 0)
                    Trigger.Size = UDim2.new(0, 100, 0, 25)
                    Trigger.AutoButtonColor = false
                    Trigger.Font = Enum.Font.Code
                    Trigger.Text = ""
                    Trigger.TextColor3 = Color3.fromRGB(235, 235, 235)
                    Trigger.TextSize = 14.000

                    Background.Name = "Background"
                    Background.Parent = Trigger
                    Background.AnchorPoint = Vector2.new(0.5, 0.5)
                    Background.BackgroundColor3 = Color3.fromRGB(17, 17, 24)
                    Background.BorderSizePixel = 0
                    Background.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Background.Size = UDim2.new(1, -2, 1, -2)

                    Value.Name = "Value"
                    Value.Parent = Trigger
                    Value.AnchorPoint = Vector2.new(1, 1)
                    Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Value.BackgroundTransparency = 1.000
                    Value.Position = UDim2.new(1, 0, 1, 0)
                    Value.Size = UDim2.new(1, 0, 1, 0)
                    Value.ZIndex = 5
                    Value.Font = Enum.Font.RobotoMono
                    Value.Text = "0"
                    Value.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Value.TextSize = 14.000

                    FillParent.Name = "FillParent"
                    FillParent.Parent = Trigger
                    FillParent.AnchorPoint = Vector2.new(0.5, 0.5)
                    FillParent.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                    FillParent.BackgroundTransparency = 1.000
                    FillParent.BorderSizePixel = 0
                    FillParent.ClipsDescendants = true
                    FillParent.Position = UDim2.new(0.5, 0, 0.5, 0)
                    FillParent.Size = UDim2.new(1, -4, 1, -4)

                    Fill.Name = "Fill"
                    Fill.Parent = FillParent
                    Fill.AnchorPoint = Vector2.new(0, 0.5)
                    Fill.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                    Fill.BorderSizePixel = 0
                    Fill.Position = UDim2.new(0, 0, 0.5, 0)
                    Fill.Size = UDim2.new(0, 0, 1, 0)


                    local Connection;
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if(Connection) then
                                Connection:Disconnect();
                                Connection = nil;
                            end;
                        end;
                    end);

                    Trigger.MouseButton1Down:Connect(function()
                        if(Connection) then
                            Connection:Disconnect();
                        end;

                        Connection = RunService.Heartbeat:Connect(function()
                            local mouse = UserInputService:GetMouseLocation();
                            local percent = math.clamp((mouse.X - Trigger.AbsolutePosition.X) / (Trigger.AbsoluteSize.X), 0, 1);
                            local Value = Properties.Min + (Properties.Max - Properties.Min) * percent;

                            if not Properties.precise then
                                Value = math.floor(Value)
                            end

                            Value = tonumber(string.format("%.2f", Value));


                            TweenService:Create(Trigger.FillParent.Fill, TweenInfo.new(0.01), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
                            Trigger.Value.Text = tostring(Value);

                            Callback(Value);
                        end);
                    end);
                    Trigger.Value.Text = tostring(Properties.Min);


                    UILib:AddInfo(Slider, {Text = InfoText}, UI)

                end

                function Items:Toggle(Properties)
                    local Callback = Properties.Callback
                    local BtnTitle = Properties.Title
                    local InfoText = Properties.InfoText
                    local Default  = Properties.Default

                    local Toggle = Instance.new("Frame")
                    local Trigger = Instance.new("TextButton")
                    local Fill = Instance.new("Frame")
                    local FillFrame = Instance.new("Frame")
                    local Title = Instance.new("TextLabel")

                    Toggle.Name = "Toggle"
                    Toggle.Parent = Section_Holder
                    Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Toggle.BackgroundTransparency = 1.000
                    Toggle.BorderSizePixel = 0
                    Toggle.Size = UDim2.new(1, -10, 0, 25)

                    Trigger.Name = "Trigger"
                    Trigger.Parent = Toggle
                    Trigger.AnchorPoint = Vector2.new(1, 1)
                    Trigger.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                    Trigger.BorderSizePixel = 0
                    Trigger.Position = UDim2.new(1, 0, 1, 0)
                    Trigger.Size = UDim2.new(0, 25, 0, 25)
                    Trigger.AutoButtonColor = false
                    Trigger.Font = Enum.Font.Code
                    Trigger.Text = ""
                    Trigger.TextColor3 = Color3.fromRGB(235, 235, 235)
                    Trigger.TextSize = 14.000

                    Fill.Name = "Fill"
                    Fill.Parent = Trigger
                    Fill.AnchorPoint = Vector2.new(0.5, 0.5)
                    Fill.BackgroundColor3 = Color3.fromRGB(17, 17, 24)
                    Fill.BorderSizePixel = 0
                    Fill.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Fill.Size = UDim2.new(1, -2, 1, -2)

                    FillFrame.Name = "FillFrame"
                    FillFrame.Parent = Trigger
                    FillFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                    FillFrame.BackgroundColor3 = Color3.fromRGB(89, 92, 150)
                    FillFrame.BorderSizePixel = 0
                    FillFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                    FillFrame.Size = UDim2.new(1, -4, 1, -4)

                    Title.Name = "Title"
                    Title.Parent = Toggle
                    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Title.BackgroundTransparency = 1.000
                    Title.Position = UDim2.new(0, 8, 0, 0)
                    Title.Size = UDim2.new(0, 252, 1, 0)
                    Title.Font = Enum.Font.RobotoMono
                    Title.Text = BtnTitle
                    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Title.TextSize = 14.000
                    Title.TextXAlignment = Enum.TextXAlignment.Left


                    local Toggled = Default;

                    local function Togglef(value, callback)
                        if value ~= nil then Toggled = value else Toggled = not Toggled end
                        if callback then Callback(Toggled) end

                        local Size = Toggled and UDim2.new(1,-4,1,-4) or UDim2.new(0,0,0,0)
                        Trigger.FillFrame:TweenSize(Size,Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.1, true)
                    end

                    Trigger.MouseButton1Click:Connect(function()
                        Togglef(nil, true)
                    end)

                    Togglef(Toggled, false)
                    UILib:AddInfo(Toggle, {Text = InfoText}, UI)

                end

                return Items
            end

            return Items
        end

        local function isreallypressed(bind, inp)
            local key = bind
            if typeof(key) == "Instance" then
                if key.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == key.KeyCode then
                    return true;
                elseif tostring(key.UserInputType):find('MouseButton') and inp.UserInputType == key.UserInputType then
                    return true
                end
            end
            if tostring(key):find'MouseButton1' then
                return key == inp.UserInputType
            else
                return key == inp.KeyCode
            end
        end

        keybindcon = UserInputService.InputBegan:connect(function(input)
            if (not isBinding) then
                for idx, binds in next, KeyBinds do
                    local real_binding = binds.location[idx];

                    if real_binding and isreallypressed(real_binding, input) then 
                        local currentBind = binds
                        
                        local needsToBeToggled = currentBind.toggled.needed
                        if needsToBeToggled and currentBind.toggled.toggled then 
                            binds.callback()
                        elseif not needsToBeToggled then
                            binds.callback()
                        end
                    end
                end
            end
        end)

        return Tabs
    end

    return UILib
