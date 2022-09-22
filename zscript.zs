version "4.8"

//-------------------------------------------------
// *kkkkkssssshhhhhhhhhhhh*
//-------------------------------------------------
class HDPocketRadio:HDWeapon{
int channel;

	default{
		-hdweapon.droptranslation
		
		inventory.pickupmessage "Picked up a pocket radio.";
		inventory.icon "RDIOA0";
        weapon.selectionorder 101;
		weapon.slotnumber 8;
		weapon.slotpriority 7;
		scale 0.3;
		tag "UAC Pocket Radio";
		hdweapon.refid "prd";
	}

override double weaponbulk(){
		return 10;
	}

override string,double getpickupsprite(bool usespare){
		return "RDIOA0",0.6;
	}

override string gethelptext(){
		return
		WEPHELP_FIRE.."  Switch to next channel\n"
   ..WEPHELP_ALTFIRE.."  Switch to previous channel\n\n"

    ..WEPHELP_UNLOAD.."  Turn off radio\n";
	}

action string RadioMsg(){
    return "Playing ch. "..invoker.channel; 
    }

	states{
	select0:
		TNT1  A 0{
			A_TakeInventory("NulledWeapon");
		}
		#### A 0;
		---- A 1 A_Raise();
		---- A 1 A_Raise(30);
		---- A 1 A_Raise(30);
		---- A 1 A_Raise(24);
		---- A 1 A_Raise(18);
		wait;

	deselect0:
		TNT1  A 0;
		---- AAA 1 A_Lower();
		---- A 1 A_Lower(18);
		---- A 1 A_Lower(24);
		---- A 1 A_Lower(30);
		wait;

	ready:
		TNT1  A 0 ;
		#### # 1 A_WeaponReady(WRF_ALL);
		goto readyend;

 fire:
  nextchannel:
  ----  A 0 {
            invoker.channel++;
            A_JumpIf(invoker.channel>99,JustPressed(BT_UNLOAD));
            S_ChangeMusic("rdioch"..invoker.channel);
            A_WeaponMessage(RadioMsg(),50);
            }
  goto nope;

altfire:
  prevchannel:
  ----  A 0 {invoker.channel--;
            If(invoker.channel<1)invoker.channel=99;
            S_ChangeMusic("rdioch"..invoker.channel);
            A_WeaponMessage(RadioMsg(),50);
            }
  goto nope;

unload:
  shutoff:
  ----  A 0 {A_WeaponMessage("Radio turned off.",50); 
             S_ChangeMusic("*");
             invoker.channel=0;
             }
  goto nope;

	spawn:
		RDIO A -1;
		stop;
	
	}
}
