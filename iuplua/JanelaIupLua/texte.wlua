require( "iuplua" )

img1 = iup.image
{
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1},
  {2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2},
  {2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2},
  {2,2,2,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2},
  {2,2,2,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2},
  {2,2,2,3,2,3,2,3,2,2,3,2,2,2,3,3,3,2,2,2,3,3,2,3,2,2,3,3,3,2,2,2},
  {2,2,2,3,2,3,3,2,3,3,2,3,2,3,2,2,2,3,2,3,2,2,3,3,2,3,2,2,2,3,2,2},
  {2,2,2,3,2,3,2,2,3,2,2,3,2,2,2,2,2,3,2,3,2,2,2,3,2,3,2,2,2,3,2,2},
  {2,2,2,3,2,3,2,2,3,2,2,3,2,2,3,3,3,3,2,3,2,2,2,3,2,3,3,3,3,3,2,2},
  {2,2,2,3,2,3,2,2,3,2,2,3,2,3,2,2,2,3,2,3,2,2,2,3,2,3,2,2,2,2,2,2},
  {2,2,2,3,2,3,2,2,3,2,2,3,2,3,2,2,2,3,2,3,2,2,3,3,2,3,2,2,2,3,2,2},
  {2,2,2,3,2,3,2,2,3,2,2,3,2,2,3,3,3,3,2,2,3,3,2,3,2,2,3,3,3,2,2,2},
  {2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,2,2,2,2,2,2,2,2},
  {2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,2,2,2,3,2,2,2,2,2,2,2,2},
  {2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,2,2,2,2,2,2,2,2,2},
  {2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2},
  {2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2},
  {1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
  colors =
  {
    "BGCOLOR", -- 1
    "255 0 0", -- 2
    "0 0 0"    -- 3  (changed because of Lua index starts at 1)
  }
}

img2 = iup.image
{
  {2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2},
  {2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2},
  {2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2},
  {2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2},
  {2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2},
  {2,2,2,2,2,2,2,2,2,2,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2},
  {2,2,2,2,2,2,2,2,2,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2},
  {2,2,2,2,2,2,2,2,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2},
  {3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3},
  {3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3},
  {3,3,3,4,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3},
  {3,3,3,4,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3},
  {3,3,3,4,3,4,3,4,3,3,4,3,3,3,1,1,4,3,3,3,4,4,3,4,3,3,4,4,4,3,3,3},
  {3,3,3,4,3,4,4,3,4,4,3,4,3,4,1,1,3,4,3,4,3,3,4,4,3,4,3,3,3,4,3,3},
  {3,3,3,4,3,4,3,3,4,3,3,4,3,3,1,1,3,4,3,4,3,3,3,4,3,4,3,3,3,4,3,3},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {3,3,3,4,3,4,3,3,4,3,3,4,3,4,1,1,3,4,3,4,3,3,4,4,3,4,3,3,3,4,3,3},
  {3,3,3,4,3,4,3,3,4,3,3,4,3,3,1,1,4,4,3,3,4,4,3,4,3,3,4,4,4,3,3,3},
  {3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,4,3,3,3,3,3,3,3,3},
  {3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,4,3,3,3,4,3,3,3,3,3,3,3,3},
  {3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,4,4,4,3,3,3,3,3,3,3,3,3},
  {3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3},
  {3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3},
  {2,2,2,2,2,2,2,3,3,3,3,3,3,3,1,1,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2},
  {2,2,2,2,2,2,3,3,3,3,3,3,3,3,1,1,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2},
  {2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2},
  {2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2},
  {2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2},
  {2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2},
  {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2},
  {3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2};
  colors =
  {
    "0 255 0", -- 1
    "BGCOLOR", -- 2
    "255 0 0", -- 3
    "0 0 0"    -- 4
  }
}

mnu = iup.menu
{
  iup.submenu
  {
    iup.menu
    {
      iup.item{title="IupItem 1 Checked",value="ON"},
      iup.separator{},
      iup.item{title="IupItem 2 Disabled",active="NO"}
    } 
    ;title="IupSubMenu 1"
  },
  iup.item{title="IupItem 3"},
  iup.item{title="IupItem 4"}
}

dlg = iup.dialog
{
  iup.vbox
  {
    iup.hbox
    {
      iup.frame
      {                   
        iup.vbox
        {
          iup.button{title="Button Text"},
          iup.button{title="",image=img1},
          iup.button{title="",image=img1,impress=img2}
        }
        ;title="IupButton"
      },
      iup.frame
      {                   
        iup.vbox
        {
          iup.label{title="Label Text"},
          iup.label{title="",separator="HORIZONTAL"},
          iup.label{title="",image=img1}
        }
        ;title="IupLabel"
      },
      iup.frame
      {                   
        iup.vbox
        {
          iup.toggle{title="Toggle Text", value="ON"},
          iup.toggle{title="",image=img1,impress=img2},
          iup.frame
          {                   
            iup.radio
            {
              iup.vbox
              {
               iup.toggle{title="Toggle Text"},
               iup.toggle{title="Toggle Text"}
              }
            }
            ;title="IupRadio"
          }
        }
        ;title="IupToggle"
      },
      iup.frame
      {                   
        iup.vbox
        {
          iup.text{size="80x",value="IupText Text"},
          iup.multiline{size="80x60",expand="YES",value="IupMultiline Text\nSecond Line\nThird Line"}
        }
        ;title="IupText/IupMultiline"
      },
      iup.frame
      {                   
        iup.vbox
        {
          iup.list{"Item 1 Text","Item 2 Text","Item 3 Text"; expand="YES",value="1"},
          iup.list{"Item 1 Text","Item 2 Text","Item 3 Text"; dropdown="YES",expand="YES",value="2"},
          iup.list{"Item 1 Text","Item 2 Text","Item 3 Text"; editbox="YES",expand="YES",value="3"}
        }     
        ;title="IupList"
      }
    },
    iup.canvas{bgcolor="128 255 0"}
    ;gap="5",alignment="ARIGHT",margin="5x5"
  }
  ;title="IupDialog Title", menu=mnu 
}

function dlg:close_cb()
  iup.ExitLoop()
  dlg:destroy()
  return iup.IGNORE
end

dlg:show()

if (iup.MainLoopLevel()==0) then
  iup.MainLoop()
end