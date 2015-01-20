#!/bin/bash
# Back In A Minute created by Sigg3.net (C) 2014
# Code is GNU GPLv3 & ASCII art is CC BY-NC-SA 4.0
VERSION="1.4 LEGACY"
WEBURL="http://sigg3.net/biamin/"

########################################################################
# BEGIN CONFIGURATION                                                  #
# Default dir for config, change at runtime (no trailing slash!)       #
GAMEDIR="$HOME/.biamin"                                                #
#                                                                      #
# Disable BASH history for this session                                #
unset HISTFILE                                                         #
#                                                                      #
# Hero start location e.g. Home (custom maps only):                    #
START_LOCATION="C2"                                                    #
#                                                                      #
# Disable Cheats 1 or 0 (chars with >150 health set to 100 health )    #
DISABLE_CHEATS=0                                                       #
#                                                                      #
# Get updates from git repository (code, legacy or gpl-only)           #
REPO_EDITION="legacy"                                                  #
#                                                                      #
# Editing beyond this line is considered unsportsmanlike by some..!    #
# END CONFIGURATION                                                    #
#                                                                      #
# 'Back in a minute' uses the following coding conventions:            #
#                                                                      #
#  0. Variables are written in ALL_CAPS                                #
#  1. Functions are written in CamelCase                               #
#  2. Loop variables are written likeTHIS                              #
#  3. Put the right code in the right blocks (see INDEX below)         #
#  4. Please explain functions right underneath function declarations  #
#  5. Comment out unfinished or not working new features               #
#  6. If something can be improved, mark with TODO + ideas             #
#  7. Follow the BASH FAQ practices @ www.tinyurl.com/bashfaq          #
#  8. Please properly test your changes, don't break anyone's heart    #
#  9. $(grep "$ALCOHOLIC_BEVERAGE" fridge) only AFTER coding!          #
#                                                                      #
#  INDEX                                                               #
#  0. GFX Functions Block (~ 600 lines ASCII banners)                  #
#  1. Functions Block                                                  #
#  2. Runtime Block (should begin by parsing CLI arguments)            #
#                                                                      #
#  Please observe conventions when updating the script, thank you.     #
#                                           - Sigg3                    #
#                                                                      #
########################################################################

########################################################################
#                                                                      #
#                        0. GFX FUNCTIONS                              #
#                All ASCII banner-functions go here!                   #

# Horizontal ruler used almost everywhere in the game
HR="- ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ "

GX_BiaminTitle() { # Used in GX_Banner(), GX_Credits(), GX_HowTo() and License() !
    clear
    cat <<"EOT"
            ______                                                     
          (, /    )       /)     ,                    ,               
            /---(  _   _ (/_      __     _     ___     __      _/_  _ 
         ) / ____)(_(_(__/(__  _(_/ (_  (_(_   // (__(_/ (_(_(_(___(/_
        (_/ (   
EOT
}  

GX_Banner() {
    GX_BiaminTitle
    cat <<"EOT"
                                                     ___________(  )_ 
                                                    /   \      (  )  \
                                                   /     \     |`|    \   
                                                  /   _   \      ~ ^~  \ ~ ^~  
                                                 /|  |.|  |\___ (     ) (     )
                                                  |  | |  |    ( (     ) (     )
                                             """"""";::;"""""""(    )  )    )  )
                                                  ,::;;.        (_____) (_____)
                                                 ,:;::;           | |     | |
                                               ;:;:;:;            | |     | |
                                            ,;;;;;;;,            """""  """"""

                    
          /a/ |s|i|m|p|l|e| /b/a/s/h/ |a|d|v|e|n|t|u|r|e| /g/a/m/e/

              Sigg3.net (C) 2014 CC BY-NC-SA 4.0 and GNU GPL v.3
EOT
    echo "$HR"
}

GX_Credits() {
    GX_BiaminTitle
    cat <<"EOT" 
          
   Back in a minute is an adventure game with 4 playable races, 6 enemies,
   8 items and 6 scenarios spread across the 270 sections of the world map.
   Biamin saves character sheets between sessions and keeps a highscore!
   The game supports custom maps too! See --help or --usage for information.
EOT
    echo -e "\n   Game directory: $GAMEDIR/\n"
    cat <<"EOT"
   This timekiller's written entirely in BASH. It was intended for sysadmins
   but please note that it isn't console-friendly and it looks best in 80x24
   terminal emulators (white on black). Make sure it's a window you can close.
      
   BASH code (C) Sigg3.net GNU GPL Version 3 2014
   ASCII art (C) Sigg3.net CC BY-NC-SA 4.0 2014 (except figlet banners)

EOT
    echo "   Visit the Back in a minute website at <$WEBURL>"
    echo "   for updates, feedback and to report bugs. Thank you."
    echo "$HR"
}

GX_HowTo() {
    GX_BiaminTitle
    cat <<"EOT"
    
                          HOW TO PLAY Back in a Minute

   Go to Main Menu and hit (P)lay and enter the NAME of the character you want
   to create or whose character sheet you want to load (case-sensitive).
   You enter the World of Back in a Minute. The first sector is Home.
   
   Each sector gives you these action alternatives:
   (C)haracter sheet: Toggle Character Sheet
   (R)est: Sleep to gain health points
   (M)ap and travel: Toggle Map to find yourself, items and to travel
   (Q)uit: Save current status and quit the world of Back in a Minute
   Use W, A, S, D keys to travel North, West, South or East directly.
      
   Travelling and resting involves the risk of being attacked by the creatures
   inhabiting the different scenarios. Some places are safer than others.
EOT
    echo -e "   For more information please visit <$WEBURL>\n$HR"
    read -sn 1 -p "                       Press any key to return to (M)ain Menu"
}

GX_HighScore() {
    clear
    cat <<"EOT"
         _________     _    _ _       _                            
        |o x o x o|   | |__| (_) __ _| |__  ___  ___ ___  _ __ ___ 
         \_*.*.*_/    |  __  | |/ _` | '_ \/ __|/ __/ _ \| '__/ _ \
           \-.-/      | |  | | | (_| | | | \__ \ (_| (_) | | |  __/
           _| |_      |_|  |_|_|\__, |_| |_|___/\___\___/|_|  \___|
          |_____|                |___/                              
                                       Y e   H a l l e   o f   F a m e
EOT
    echo "$HR"
}

GX_LoadGame() {
    clear
    cat << "EOT"
        ___________ 
       (__________()   _                    _    ____                      
       / ,,,,,,,  /   | |    ___   __ _  __| |  / ___| __ _ _ __ ___   ___ 
      / ,,,,,,,  /    | |   / _ \ / _` |/ _` | | |  _ / _` | '_ ` _ \ / _ \
     / ,,,,,,,  /     | |__| (_) | (_| | (_| | | |_| | (_| | | | | | |  __/
   _/________  /      |_____\___/ \__,_|\__,_|  \____|\__,_|_| |_| |_|\___|
  (__________(/ 
 

EOT
    echo "$HR"
}

GX_CharSheet() {
    clear
    cat <<"EOT"
 
                               /T\                           /""""""""\ 
      o-+----------------------------------------------+-o  /  _ ++ _  \
        |/                                            \|   |  / \  / \  \
        |  C  H  A  R  A  C  T  E  R     S  H E  E  T  |   | | , | |, | |
        |                                              |   | |   |_|  | |
        |\             s t a t i s t i c s            /|    \|   ...; |; 
      o-+----------------------------------------------+-o    \______/

EOT
    echo "$HR"
}

GX_Death() {
    clear
    cat <<"EOT"

     
         __   _  _  _/_   ,  __
        / (__(/_/_)_(__  _(_/ (_    __    _  _   _   _                __ 
                                    /_)__(/_(_(_(___(/_              /\ \
                                 .-/                                /  \ \   
         YOU ARE A STIFF,       (_/           # #  # #  # # #      /  \/\ \  
         PUSHING UP THE DAISIES          # # #  # # # # # # #  #  /   /\ \_\ 
         YOU ARE IRREVOCABLY DEAD     # # # # # #  # # # # #  # # \  /   / / 
                                    # # # # # # # # # ## # # # # # \    / /     
         Better luck next time!   # # # # #  # # # # # # # # #  # # \  / /
                                 # # #  #  # # # # # # # # # # # # # \/_/
                                   # #  # # # # # # ## # # # # ## #


EOT
    echo "$HR"
}

GX_Intro() {
    clear
    cat <<"EOT"
                                                                         
       YOU WAKE UP TO A VAST AND UNFAMILIAR LANDSCAPE !                   
                                                                          
       Use the MAP to move around                                         
       REST to regain health points                                             
                                 ___                ^^                /\        
       HOME, TOWNS and the    __/___\__                   ^^         /~~\      
       CASTLE are safest       _(   )_                           /\ /    \  /\
                              /       \    1                  __/  \      \/  \
___                          (         \__ 1                _/             \   \
   \________                  \       L___| )           @ @ @ @ @@ @ @@ @
            \_______________   |     |     1     @ @ @ @@ @ @ @@ @ @ @ @ @@ @
                            \__|  |  |_____1____                    @ @ @@ @@ @@
                               |  |  |_    1    \___________________________  
                               |__| ___\   1                                \___
EOT
    echo "$HR"
}

GX_Races() {
    clear
    cat <<"EOT"

                        C H A R A C T E R   R A C E S :

      1. MAN            2. ELF              3. DWARF            4. HOBBIT
 
   Healing:  3/6      Healing:  4/6       Healing:  2/6        Healing:  4/6   
   Strength: 3/6      Strength: 3/6       Strength: 5/6        Strength: 1/6
   Accuracy: 3/6      Accuracy: 4/6       Accuracy: 3/6        Accuracy: 4/6
   Flee:     3/6      Flee:     1/6       Flee:     2/6        Flee:     3/6
   
   
   Dice rolls on each turn. Accuracy also initiative. Healing during resting.

EOT
    echo "$HR"
}

GX_Castle() {
    clear
    cat <<"EOT"
                             __   __   __                         __   __   __ 
                            |- |_|- |_| -|   ^^                  |- |_|- |_|- |
                            | - - - - - -|                       |- - - - - - |
                             \_- - - - _/    _       _       _    \_ - - - -_/
         O L D B U R G         |- - - |     |~`     |~`     |~`     | - - -| 
         C A S T L E           | - - -|  _  |_   _  |_   _  |_   _  |- - - | 
                               |- - - |_|-|_|-|_|-|_|-|_|-|_|-|_|-|_| - - -| 
         Home of The King,     | - - -|- - - - - -_-_-_-_- - - - - -|- - - | 
         The Royal Court and   |- - - | - - - - //        \ - - - - | - - -| 
         other silly persons.  | - - -|- - - - -||        |- - - - -|- - - | 
                               |- - - | - - - - ||        | - - - - | - - -| 
                               | - - -|- - - - -||________|- - - - -|- - - | 
                               |- - - | - - - - /        /- - - - - | - - -| 
                               |_-_-_-_-_-_-_-_/        /-_-_-_-_-_-_-_-_-_| 
                                              7________/
EOT
    echo "$HR"
}

GX_Town() {
    clear
    cat <<"EOT"
                                                           ___ 
                                                          / \_\   town house
                                 zig's inn                | | |______
         YOU HAVE REACHED   ______________________________| | |\_____\____
         A PEACEFUL TOWN   |\| | | | _|_|_| | | |/\____\ .|_|_|______| | |\
                            |\   _  /\____\  ....||____| :........  ____  |\
         A warm bath and     |  [x] ||____|  :   _____ ..:_____  : /\___\  |\
         cozy bed awaits    ........:        :  /\____\  /\____\ :.||___|   |\
         the weary traveller   |\   :........:..||____|  ||____|             |\
                                ||==|==|==|==|==|==|==|==|==|==|==|==|==|==|==|


EOT
    echo "$HR"
}

GX_Forest() {
    clear
    cat <<"EOT"
                                                                    /\
                                                                   //\\     
                                        /\  /\               /\   /\/\/\ 
                                       /  \//\\             //\\ //\/\\/\
         YOU'RE IN THE WOODS          /    \^#^\           /\/\/\/\^##^\/\      
                                     /      \#            //\/\\/\  ##      
         It feels like something    /\/^##^\/\        .. /\/^##^\/\ ##      
         is watching you ..             ##        ..::;      ##     ##      
                                        ##   ..::::::;       ##
                                       ....::::::::;;        ## 
                                   ...:::::::::::;;
                                ..:::::::::::::::;
EOT
    echo "$HR"
}

GX_Mountains() {
    clear
    cat <<"EOT"


                                           ^^      /\  /\_/\/\
         YOU'RE TRAVELLING IN           ^^     _  /~~\/~~\~~~~\   
         THE MOUNTAINS                        / \/    \/\      \
                                             /  /    ./  \ /\   \/\ 
         The calls of the wilderness  ............:;'/    \     /  
         turn your blood to ice        '::::::::::; /     




EOT
    echo "$HR"
}

GX_Home() {
    clear
    cat <<"EOT"
                                                     ___________(  )_ 
                                                    /   \      (  )  \
                                                   /     \     |`|    \   
                                                  /   _   \      ~ ^~  \ ~ ^~  
         MY HOME IS MY CASTLE                    /|  |.|  |\___ (     ) (     )
                                                  |  | |  |    ( (     ) (     )
         You are safe here                   """"""";::;"""""""(    )  )    )  )
         and fully healed.                        ,::;;.        (_____) (_____)
                                                 ,:;::;           | |     | |
                                               ;:;:;:;            | |     | |
                                            ,;;;;;;;,            """""  """"""

EOT
    echo "$HR"
}

GX_Road() {
    clear
    cat <<"EOT"
                             /V/V7/V/\V\V\V\
                            /V/V/V/V/V/V/V\V\                ,      ^^ 
                           /7/V/V/V###V\V\V\V\    ^^      , /X\           ,
                                   ###     ,____________ /x\ T ____  ___ /X\ ___
         ON THE ROAD AGAIN         ###   ,-               T        ; ;    T  
                              ____ ### ,-______  ., . . . . , ___.'_;_______
         Safer than the woods      ###        .;'          ;                \_
         but beware of robbers!            .:'            ;                   \ 
                                        .:'              ;   ___               `
                                *,    .:'               .:  | 3 |     
                               `)    :;'                :; '"""""'    
                                   .;:                   `::.            
EOT
    echo "$HR"
}

GX_Rest() {
    clear
    cat <<"EOT"


                                                          _.._    
                               *         Z Z Z   *       -'-. '.             *
                                                             \  \          
         YOU TRY TO GET                                .      | |
         SOME MUCH NEEDED REST    *                    ;.___.'  /     *    
                                    Z Z    *            '.__ _.'          * 
                            *                                               



EOT
    echo "$HR"
}

GX_Monster_chthulu() {
    clear
    cat <<"EOT"
                        \ \_|\/\     ________      / /            \ \ 
                         \ _    \   /        \    /  /             \ \
         T H E            \ \____\_|          \--/  /__   ____      \ \ 
         M I G H T Y       \_    _|            |       ) / __ )      \ \
                             \  / \    .\  /.  |        / |  (_   __  \ \
         C H T H U L U ' S    \/    \         /       _/ /|  | \_/  )  \ \     
                              /   _/         \      / _/   \/   /-/|    \ \     
         W R A T H   I S     /   //.(/((| |\(\\    / /          \/ |     \ \   (
         U P O N   Y O U    /   / ||__ "| |   \|  |_ |----------L /       \ \ _/
                           /   /  \__/  | |/|      \_) \        |/         \_/
                          /   /     |    \_/            \               __(
                          |   (      |                   \           __(
                          \|\|\\      |                   `         (  

EOT
    echo "$HR"
}

GX_Monster_orc() {
    clear
    cat <<"EOT"
                                                  |\            /|
                                                  | \_.::::::._/ |
                                                   |  __ \/__   |
                                                    |          |
         AN ANGRY ORC APPEARS,                  ____| _/|__/|_ |____
         BLOCKING YOUR WAY!                    /     \________/     \
                                              /                      \
         "Prepare to die", it growls.        |    )^|    _|_   |^(    |
                                             |   )  |          |  (   |
                                             |   |   |        |   (   |
                                              \_\_) |          | (_/_/
                                                   /     __     \
                                                  |     /  \     |
                                                  |    (    )    |
                                                  |____'    '____|
                                                 (______)  (______)
EOT
    echo "$HR"
}

GX_Monster_varg() {
    clear
    cat <<"EOT"

                                                     ______
                                               ____.:      :.
                                        _____.:               \___
         YOU ENCOUNTER A         _____/  _  )      __            :.__
         TERRIBLE VARG!         |       7             `      _       \ 
                                  ^^^^^ \    ___        1___ /        |
         It looks hungry.           ^^^^  __/   |    __/    \1     /\  |
                                     \___/     /   _|        |    / | /  _
                                            __/   /           |  \  | | | |
                                           /_    /           /   |   \ ^  |
                                             /__/           |___/     \__/


EOT
    echo "$HR"
}

GX_Monster_mage() {
    clear
    cat <<"EOT"
                                             ---.         _/""""""\
                                            (( ) )       /_____  |'
                                             \/ /       // \/  \  \
                                             / /       ||(.)_(.)|  |
                                             (|`\      ||  ( ;  |__|
         A FIERCE MAGE STANDS                (|  \      7| +++   /
         IN YOUR WAY!                        ||__/\____/  \___/  \___
                                             ||      |             /  \
         Before you know it, he begins       ||       \     \/    /    \
         his evil incantations..             ||\       \   ($)   /      \
                                             || \   /^\ \ ______/  ___   \
         "Lorem ipsum dolor sit amet..."     ||  \_/  |           /  __   |
                                             ||       |          |  /__|  |
                                             ||       |          \  |__/  | 
                                             ||      /            \_____/ 
                                             ^      /               \
                                                   |        \        \
EOT
    echo "$HR"
}

GX_Monster_goblin() {
    clear
    cat <<"EOT"
                                                    _______                   _
                                                   (       )/|    ===[]]]====(_)
                                                ____0(0)    /       7 _/^
                                                L__  _)  __/       / / 
         A GOBLIN JUMPS YOU!                      /_V)__/ 1       / / 
                                             ______/_      \____ / /
         He raises his club to attack..     /   .    \      _____/
                                           |  . _ .   | .__/|
                                           | . (_) .  |_____|
                                           |  . . .   |$$$$$|  
                                            \________/$$$$$/ \
                                                 /  /\$$$$/\  \
                                             ___/  /      __|  \
                                            (_____/      (______)
EOT
    echo "$HR"
}

GX_Monster_bandit() {
    clear
    cat <<"EOT"
                                                       /""""""';   ____
                                                      d = / =  |3 /1--\\
                                                 _____| _____  |_|11 ||||
         YOU ARE INEXPLICABLY                   /     \_\\\\\\_/  \111/// 
         AMBUSHED BY A LOWLIFE CRIMINAL!       /  _ /             _\1// \ 
                                              /  ) (     |        \ 1|\  \
         "Hand over your expensive stuffs,   /   )(o____ (   ____o) 1|(  7
         puny poncer, or have your skull     \   \ :              . 1/  /
         cracked open by the mighty club!"    \\\_\'.     *       ;|___/
                                                   /\____________/ 
                                                  / #############/
                                                 (    ##########/ \
                                                __\    \    \      )__
                                               (________)    (________)
EOT
    echo "$HR"
}

GX_Item0() {
    clear
    cat <<"EOT"
		
                          G I F T   O F   S I G H T

                                .............. 
                                ____________**:,.                      
                             .-'  /      \  ``-.*:,..             
                         _.-*    |  .jM O |     `-..*;,,              
                        `-.      :   WW   ;       .-'                 
                   ....    '._    \______/     _.'   .:              
                      *::...  `-._ _________,;'    .:*
                          *::...                 ..:*      
                               *::............::*                  
                                                                   
     You give aid to an old woman, carry her firewood and water from the
     stream, and after a few days she reveals herself as a White Witch!
	
     She gives you a blessing and the Gift of Sight in return for your help.
     "The Gift of Sight," she says, "will aide you as you aided me."

     Look for a ~ symbol in your map to discover new items in your travels.
     However, from the 7 remaining items only 1 is made visible at a time.

EOT
    echo "$HR"
}

GX_Item1() {
    clear
    cat <<"EOT"

                  E M E R A L D   O F   N A R C O L E P S Y
                             .   .  ____  .   .
                                .  /.--.\  .  
                               .  //    \\  .  
                            .  .  \\    //  .  .
                                .  \\  //  .     
                             .   .  \`//  .   .        
                                     \/     
     You encounter a strange merchant from east of all maps who joins you
     for a stretch of road. He is a likeable fellow, so when he asks if he
     could share a campfire with you and finally get some much needed rest in
     these strange lands, you comply.

     The following day he presents you with a brilliant emerald that he says
     will help you sleep whenever you need to get some rest. Or at least
     fetch you a good price at the market. Then you bid each other farewell.

     +1 Healing, Chance of Healing Sleep when you are resting.
	
EOT
    echo "$HR"
}

GX_Item2() {
    clear
    cat <<"EOT"

                          G U A R D I A N   A N G E L
                        .    . ___            __ ,  .            
                      .      /* * *\  ,~-.  / * *\    .         
                            /*   .:.\ l`; )/*    *\             
                     .     |*  /\ :-,_,' ()*  /\  *|    .       
                           \* |  ||\__   ~'  |  | */           
                      .     \* \/ |  / /\ \  \ / */   .      
                             \*     / ^  ^ \    */               
                        .     )* _  ^|^|^|^^ _ *(    .
                             /* /     |  |    \ *\ 
                       .    (*  \__,   | | .__/  *)   .
                             \*  *_*_ // )*_*   */     
                        .     \* /.,  `-'   .\* /    .  
                          .    \/    .   .   `\/        
                            .     .         .     .
                              .                 .
     You rescue a magical fairy caught in a cobweb, and in return she
     promises to come to your aid when you are caught in a similar bind.

     +5 Health in Death if criticality is less than or equal to -5

EOT
    echo "$HR"
}

GX_Item3() {
    clear
    cat <<"EOT"

                        F A S T   M A G I C   B O O T S
                              _______  _______                                 
                             /______/ /______/                            
                              |   / __ |   / __                           
                             /   /_(  \'  /_(  \                       
                            (_________/________/       
                                                                     
     You are taken captive by a cunning gnome with magic boots, holding you
     with a spell that can only be broken by guessing his riddles.
     After a day and a night in captivity you decide to counter his riddles
     with one of your own: "What Creature of the Forest is terribly Red and
     Whiny, and Nothing Else without the Shiny?"
     
     The gnome ponders to and fro, talking to himself and spitting, as he gets
     more and more agitated. At last, furious, he demands "Show me!" and 
     releases you from the spell. Before he knows it you've stripped off his
     boots and are running away, magically quicker than your normal pace.

     +1 Flee

EOT
    echo "$HR"
}

GX_Item4() {
    clear
    cat <<"EOT"

                    Q U I C K   R A B B I T   R E A C T I O N

                                   .^,^   
                                __/ ; /____
                               / c   -'    `-.                            
                              (___            )              
                                  _) .--     _')                
                                  `--`  `---'               
                                                        
     Having spent quite a few days and nights out in the open, you have grown
     accustomed to sleeping with one eye open and quickly react to the dangers
     of the forests, roads and mountains in the old world, that seek every
     opportunity to best you.

     Observing the ancient Way of the Rabbit, you find yourself reacting more
     quickly to any approaching danger, whether it be day or night.

     +1 Initiative upon enemy attack

EOT
    echo "$HR"
}

GX_Item5() {
    clear
    cat <<"EOT"

                  F L A S K   O F   T E R R I B L E   O D O U R
                        /  /    * *  /    _\ \       ___ _
                        ^ /   /  *  /     ____)     /,- \ \              
                         /      __*_     / / _______   \ \ \             
                 ,_,_,_,_ ^_/  (_+ _) ,_,_/_/       ) __\ \_\___        
                /          /  / |  |/     /         \(   \7     \    
           ,   :'      \    ^ __| *|__    \    \  ___):.    ___) \____/)
          / \  :.       |    / +      \  __\    \      :.              (\  
        _//^\\  ;.      )___(~~~~~~~*~~)_\_____  )_______:___            }   
        \ |  \\_) ) _____,)  \________/   /_______)          vvvVvvvVvvvV 
         \|   `-.,'               
     Under a steep rock wall you encounter a dragon pup's undiscovered carcass.
     You notice that its rotten fumes curiously scare away all wildlife and
     lowlife in the surrounding area.
     You are intrigued and collect a sample of the liquid in a small flask that
     you carry, to sprinkle on your body for your own protection.

     +1 Chance of Enemy Flee

EOT
    echo "$HR"
}

GX_Item6() {
    clear
    cat <<"EOT"

                   T W O - H A N D E D    B R O A D S W O R D
                       .   .   .  .  .  .  .  .  .  .  .  . 
                  .  .   /]______________________________   .
                .  ,~~~~~|/_____________________________ \   
                .  `=====|\______________________________/  .
                  .  .   \]   .  .  .  .  .  .  .  .  .   .      
                        .  .                                                           
     From the thickest of forests you come upon and traverse a huge unmarked 
     marsh and while crossing, you stumble upon trinkets, shards of weaponry
     and old equipment destroyed by the wet. Suddenly you realize that you are
     standing on the remains of a centuries old, long forgotten battlefield.

     On the opposite side, you climb a mound only to find the wreckage of a
     chariot, crashed on retreat, its knight pinned under one of its wheels.
     You salvage a beautiful piece of craftmanship from the wreckage;
     a powerful two-handed broadsword, untouched by time.
		
     +1 Strength
	
EOT
    echo "$HR"
}

GX_Item7() {
    clear
    cat <<"EOT"

                      S T E A D Y   H A N D   B R E W
                              ___                                
                             (___)            _  _  _ _             
                              | |           ,(  ( )  ) )                
                             /   \         (. ^ ( ^) ^ ^)_
                            |     |        ( ~( _)- ~ )-_ \    
                            |-----|         [_[[ _[[ _{  } :       
                            |X X X|         [_[[ _[[ _{__; ;      
                            |-----|         [_[[ _[[ _)___/                    
              ______________|     |   _____ [_________]                 
             |     | >< |   \___ _| _(     )__
             |     | >< |    __()__           )_                              
             |_____|_><_|___/     (__          _)                      
                                    (_________)      

     Through the many years of travel you have found that your acquired taste
     of a strong northlandic brew served cool keeps you on your toes.

     +1 Accuracy and Initiative

EOT
    echo "$HR"
}

# GFX MAP FUNCTIONS
MapCreate() { # FILL THE $MAP file using either default or custom map
    if [ -f "$GAMEDIR/CUSTOM.map" ]; then # Try to load Custom map
	grep -q 'Z' "$GAMEDIR/CUSTOM.map" && CustomMapError # And exit after CustomMapError
	MAP=$(cat "$GAMEDIR/CUSTOM.map")
    else # Load default map
	# Dirty fix for MacOS - it doesn't understand 	'MAP=$(cat <<EOT'
	# I know that it's unreadable, but I can't find better variant now :( #kstn
	MAP='       A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R 
   #=========================================================================#
 1 )   x   x   x   x   x   @   .   .   .   T   x   x   x   x   x   x   @   T (
 2 )   x   x   H   x   @   @   .   @   @   x   x   x   x   x   @   @   @   @ (
 3 )   @   @   .   @   @   @   .   x   x   x   x   x   @   x   @   x   @   @ (
 4 )   @   @   .   @   @   @   .   @   x   x   x   @   T   x   x   x   x   x (
 5 )   @   @   .   .   T   .   .   @   @   @   @   @   .   @   x   x   x   x (
 6 )   @   @   @   @   .   @   @   @   @   @   @   @   .   @   @   x   x   x (
 7 )   @   @   @   @   .   .   .   T   @   @   @   @   .   @   @   x   x   x (
 8 )   @   @   T   .   .   @   @   @   @   @   @   .   .   .   .   .   .   x (
 9 )   @   @   .   @   @   @   @   @   @   @   .   .   @   x   @   @   .   . (
10 )   @   @   .   @   @   @   T   @   @   @   .   @   @   x   x   x   x   . (
11 )   T   .   .   .   .   .   .   .   @   @   .   x   x   C   x   x   x   . (
12 )   x   @   @   @   .   @   @   .   .   .   .   x   x   x   x   x   x   . (
13 )   x   x   @   x   .   @   @   @   @   @   .   @   x   x   @   @   @   . (
14 )   x   x   x   x   .   @   @   @   @   T   .   @   x   x   @   @   .   . (
15 )   x   x   x   T   .   @   @   @   @   @   @   @   @   T   .   .   .   @ (
   #=========================================================================#
          LEGEND: x = Mountain, . = Road, T = Town, @ = Forest         N
                  H = Home (Heal Your Wounds) C = Oldburg Castle     W + E
                                                                       S'
    fi
}

MapCreateCustom() { # Map template generator (CLI arg function)
    [[ ! -d "$GAMEDIR" ]] && Die "Please create $GAMEDIR/ directory before running" 
    cat <<"EOT" > "${GAMEDIR}/rename_to_CUSTOM.map"
       A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R 
   #=========================================================================#
 1 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 2 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 3 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 4 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 5 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 6 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 7 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 8 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 9 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
10 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
11 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
12 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
13 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
14 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
15 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
   #=========================================================================#
          LEGEND: x = Mountain, . = Road, T = Town, @ = Forest         N
                  H = Home (Heal Your Wounds) C = Oldburg Castle     W + E
                                                                       S
EOT
    echo "Custom map template created in $GAMEDIR/rename_to_CUSTOM.map

1. Change all 'Z' symbols in map area with any of these:  x . T @ H C
   See the LEGEND in rename_to_CUSTOM.map file for details.
   Home default is $START_LOCATION. Change line 16 of CONFIG or enter new HOME at runtime.
2. Spacing must be accurate, so don't touch whitespace or add new lines.
3. When you are done, simply rename your map file to CUSTOM.map
Please submit bugs and feedback at <$WEBURL>"
}

#                          END GFX FUNCTIONS                           #
#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                                                                      #
#                          1. FUNCTIONS                                #
#                    All program functions go here!                    #

Die() {
    echo -e "$1" && exit 1
}

CleanUp() { # Used in MainMenu(), NewSector(),
    GX_BiaminTitle
    echo -e "\n$HR"
    if [[ "$FIGHTMODE" ]] ; then #  -20 HP -20 EXP Penalty for exiting CTRL+C during battle!
	(( CHAR_HEALTH -= 20 ))
	(( CHAR_EXP -= 20 ))
    	echo "PENALTY for CTRL+Chickening out during battle: -20 HP -20 EXP"
    	echo -e "HEALTH: $CHAR_HEALTH\tEXPERIENCE: $CHAR_EXP"
    fi
    [[ "$CHAR" ]] && SaveCurrentSheet # Don't try to save if we've nobody to save :)
    echo -e "\nLeaving the realm of magic behind ....\nPlease submit bugs and feedback at <$WEBURL>"
    exit 0
}
# PRE-CLEANUP tidying function for buggy custom maps
CustomMapError() { # Used in MapCreate(), NewSector() and MapNav()
    clear
    echo -n "Whoops! There is an error with your map file!
Either it contains unknown characters or it uses incorrect whitespace.
Recognized characters are: x . T @ H C
Please run game with --map argument to create a new template as a guide.

What to do?
1) rename CUSTOM.map to CUSTOM_err.map or
2) delete template file CUSTOM.map (deletion is irrevocable).
Please select 1 or 2: "
    read -n 1 MAP_CLEAN_OPTS
    case "$MAP_CLEAN_OPTS" in
	1 ) mv "$GAMEDIR/CUSTOM.map" "$GAMEDIR/CUSTOM_err.map" ;
	    Die "\nCustom map file moved to $GAMEDIR/CUSTOM_err.map" ;;
	2 ) rm -f "$GAMEDIR/CUSTOM.map" && Die "\nCustom map deleted!" || Die "Can't delete $GAMEDIR/CUSTOM.map";;
	* ) Die "\nBad option! Quitting.." ;;
    esac
}

SetupHighscore() { # Used in main() and Announce()
	HIGHSCORE="$GAMEDIR/highscore" ;
	[[ -f "$HIGHSCORE" ]] || touch "$HIGHSCORE"; # Create empty "$GAMEDIR/highscore" if not exists
	# Backwards compatibility: replaces old-style empty HS..
	grep -q 'd41d8cd98f00b204e9800998ecf8427e' "$HIGHSCORE" && echo "" > "$HIGHSCORE"
}

### DISPLAY MAP
GX_Map() { # Used in MapNav()
    if (( CHAR_ITEMS > 0 )) && (( CHAR_ITEMS < 8 )) ; then # Check for Gift of Sight
	# Show ONLY the NEXT item viz. "Item to see" (ITEM2C)
	# There always will be item in HOTZONE[0]!
     	IFS="-" read -r "ITEM2C_X" "ITEM2C_Y" <<< "${HOTZONE[0]}" # Retrieve item map positions e.g. 1-15 >> X=1 Y=15
	# Remember, the player won't necessarily find items in HOTZONE array's sequence
    else # Lazy fix for awk - it falls when see undefined variable #kstn
	ITEM2C_Y=0 && ITEM2C_X=0 
    fi

    clear

    awk '
    BEGIN { FS = "   " ; OFS = "   ";}
    {
      # place "o" (player) on map
      if (NR == '$(( MAP_Y + 2 ))') {  # lazy fix for ASCII borders
         if ('$MAP_X' == 18 ) { $'$(( MAP_X + 1 ))'="o ("; }
         else                 { $'$(( MAP_X + 1 ))'="o";   } 
         }
      # if player has Gift-Of-Sight and not all items are found
      if ( '${CHAR_ITEMS}' > 0 && '${CHAR_ITEMS}' < 8) {
         # place ITEM2C on map 
         # ITEM2C_Y+2 and ITEM2C_X+1 - fix for boards
 	 if (NR == '$(( ITEM2C_Y + 2 ))') {
            if ( '$ITEM2C_X' == 18 ) { $'$(( ITEM2C_X + 1 ))'="~ ("; }
            else                     { $'$(( ITEM2C_X + 1 ))'="~";   } 
            }
         }
      # All color on map sets here
      if ('${COLOR}' == 1 ) {
         # Terminal color scheme bugfix
         if ( NR == 1 ) { gsub(/^/, "'$(printf "%s" "${RESET}")'"); } 
         # colorise "o" (player) and "~" (ITEM2C)
	 if ( NR > 2 && NR < 19 ) {
 	    gsub(/~/, "'$(printf "%s" "${YELLOW}~${RESET}")'")
	    gsub(/o/, "'$(printf "%s" "${YELLOW}o${RESET}")'")
	    }
         }
      print;
    }' <<< "$MAP"
}
# SAVE CHARSHEET
SaveCurrentSheet() { # Saves current game values to CHARSHEET file (overwriting)
    echo "CHARACTER: $CHAR
RACE: $CHAR_RACE
BATTLES: $CHAR_BATTLES
EXPERIENCE: $CHAR_EXP
LOCATION: $CHAR_GPS
HEALTH: $CHAR_HEALTH
ITEMS: $CHAR_ITEMS
KILLS: $CHAR_KILLS
HOME: $CHAR_HOME" > "$CHARSHEET"
}

# CHAR SETUP
BiaminSetup() { # Used in MainMenu()
    # Set CHARSHEET variable to gamedir/char.sheet (lowercase)
    CHARSHEET="$GAMEDIR/$(echo "$CHAR" | tr '[:upper:]' '[:lower:]' | tr -d " ").sheet"
    # Check whether CHAR exists if not create CHARSHEET
    if [[ -f "$CHARSHEET" ]] ; then
	echo -en " Welcome back, $CHAR!\n Loading character sheet ..."
	# Fixes for older charsheets compability
	grep -q -E '^HOME:' "$CHARSHEET" || echo "HOME: $START_LOCATION" >> $CHARSHEET
	# I don't know why, but "read -r VAR1 VAR2 VAR3 <<< $(awk $FILE)" not works :(
	# But one local variable at any case is better that to open one file eight times
	local CHAR_TMP=$(awk '
                  { 
                   if (/^CHARACTER:/)  { RLENGTH = match($0,/: /);
                  	                 CHARACTER = substr($0, RLENGTH+2); }
                   if (/^RACE:/)       { RACE= $2 }
                   if (/^BATTLES:/)    { BATTLES = $2 }
                   if (/^EXPERIENCE:/) { EXPERIENCE = $2 }
                   if (/^LOCATION:/)   { LOCATION = $2 }
                   if (/^HEALTH:/)     { HEALTH = $2 }
                   if (/^ITEMS:/)      { ITEMS = $2 }
                   if (/^KILLS:/)      { KILLS = $2 }
                   if (/^HOME:/)       { HOME = $2 }
                 }
                 END { 
                 print CHARACTER ";" RACE ";" BATTLES ";" EXPERIENCE ";" LOCATION ";" HEALTH ";" ITEMS ";" KILLS ";" HOME ;
                 }' $CHARSHEET )
	IFS=";" read -r CHAR CHAR_RACE CHAR_BATTLES CHAR_EXP CHAR_GPS CHAR_HEALTH CHAR_ITEMS CHAR_KILLS CHAR_HOME <<< "$CHAR_TMP"
	unset CHAR_TMP
	# If character is dead, don't fool around..
	(( CHAR_HEALTH <= 0 )) && Die "\nWhoops!\n $CHAR's health is $CHAR_HEALTH!\nThis game does not support necromancy, sorry!"
    else
	echo " $CHAR is a new character!"
	CHAR_BATTLES=0
	CHAR_EXP=0
	CHAR_HEALTH=100
	CHAR_ITEMS=0
	CHAR_KILLS=0
	GX_Races
	read -sn 1 -p " Select character race (1-4): " CHAR_RACE
	case $CHAR_RACE in
	    2 ) echo "You chose to be an ELF" ;;
	    3 ) echo "You chose to be a DWARF" ;;
	    4 ) echo "You chose to be a HOBBIT" ;;
	    1 | * ) CHAR_RACE=1 && echo "You chose to be a HUMAN" ;;	# Not very good, but works :) #kstn
	esac
	
	CHAR_GPS="$START_LOCATION"
	CHAR_HOME="$START_LOCATION"

	# If there IS a CUSTOM.map file, ask where the player would like to start
	if [ -f "$GAMEDIR/CUSTOM.map" ] ; then
	    read -p " HOME location for custom maps (ENTER for default $START_LOCATION): " "CHAR_LOC"
	    if [[ ! -z "$CHAR_LOC" ]]; then # Use user input as start location.. but first SANITY CHECK		
		read CHAR_LOC_LEN CHAR_LOC_A CHAR_LOC_B <<< $(awk '{print length($0) " " substr($0,0,1) " " substr($0,2)}' <<< "$CHAR_LOC")
		(( CHAR_LOC_LEN > 3 )) && Die " Error! Too many characters in $CHAR_LOC\n Start location is 2-3 alphanumeric chars [A-R][1-15], e.g. C2 or P13"
		(( CHAR_LOC_LEN < 1 )) && Die " Error! Too few  characters in $CHAR_LOC\n Start location is 2-3 alphanumeric chars [A-R][1-15], e.g. C2 or P13"
		echo -n "Sanity check.."
		case "$CHAR_LOC_A" in
		    A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R ) echo -n ".." ;;
		    * ) Die "\n Error! Start location X-Axis $CHAR_LOC_A must be a CAPITAL alphanumeric A-R letter!" ;;
		esac
		case "$CHAR_LOC_B" in
		    1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 ) echo ".. Done!" ;;
		    * ) Die "\n Error! Start location Y-Axis $CHAR_LOC_B is too big or too small!";;
		esac # End of SANITY check, everything okay!
		CHAR_GPS="$CHAR_LOC"
		CHAR_HOME="$CHAR_LOC"
		unset CHAR_LOC CHAR_LOC_LEN CHAR_LOC_A CHAR_LOC_B
	    fi # or CHAR_GPS and CHAR_HOME not changed from START_LOCATION
	fi
	echo " Creating fresh character sheet for $CHAR ..."
	SaveCurrentSheet
    fi # Finish check whether CHAR exists if not create CHARSHEET 
    sleep 2 # merged sleep from 'load char' and 'new char'
    # Set abilities according to race (each equal to 12 except FLEE)
    case $CHAR_RACE in
	1 ) HEALING=3 && STRENGTH=3 && ACCURACY=3 && FLEE=3 ;; # human  (3,3,3,3)
	2 ) HEALING=4 && STRENGTH=3 && ACCURACY=4 && FLEE=1 ;; # elf    (4,3,4,1)
	3 ) HEALING=2 && STRENGTH=5 && ACCURACY=3 && FLEE=2 ;; # dwarf  (2,5,3,2)
	4 ) HEALING=4 && STRENGTH=1 && ACCURACY=4 && FLEE=3 ;; # hobbit (4,1,4,3)
    esac
    # Adjust abilities according to items
    if (( CHAR_ITEMS >= 2 )); then
	((HEALING++))			# Adjusting for Emerald of Narcolepsy
	if (( CHAR_ITEMS >= 4 )); then
	    ((FLEE++))			# Adjusting for Fast Magic Boots
	    if (( CHAR_ITEMS >= 7 )); then		
		((STRENGTH++))		# Adjusting for Broadsword
		if (( CHAR_ITEMS >= 8 )); then	
		    ((ACCURACY++))	# Adjusting for Steady Hand Brew
		fi
	    fi
	fi
    fi
    # If Cheating is disabled (in CONFIGURATION) restrict health to 150
    (( DISABLE_CHEATS == 1 )) && (( CHAR_HEALTH > 150 )) && CHAR_HEALTH=150
    Intro
}

TodaysDate() {
    # An adjusted version of warhammeronline.wikia.com/wiki/Calendar
    # Variables used in DisplayCharsheet () ($TODAYS_DATE_STR), and
    # in FightMode() ($TODAYS_DATE_STR, $TODAYS_DATE, $TODAYS_MONTH, $TODAYS_YEAR)
    read -r "TODAYS_YEAR" "TODAYS_MONTH" "TODAYS_DATE" <<< "$(date '+%-y %-m %-d')"
    # Adjust date
    case "$TODAYS_DATE" in
	1 | 21 | 31 ) TODAYS_DATE+="st" ;;
	2 | 22 ) TODAYS_DATE+="nd" ;;
	3 | 23 ) TODAYS_DATE+="rd" ;;
 	* ) TODAYS_DATE+="th" ;;
    esac
    # Adjust month
    case "$TODAYS_MONTH" in
	1 ) TODAYS_MONTH="After-Witching" ;;
	2 ) TODAYS_MONTH="Year-Turn" ;;
	3 ) TODAYS_MONTH="Plough Month" ;;
	4 ) TODAYS_MONTH="Sigmar Month" ;;
	5 ) TODAYS_MONTH="Summer Month" ;;
	6 ) TODAYS_MONTH="Fore-Mystery" ;;
	7 ) TODAYS_MONTH="After-Mystery" ;;
	8 ) TODAYS_MONTH="Harvest Month" ;;
	9 ) TODAYS_MONTH="Brew Month" ;;
 	10 ) TODAYS_MONTH="Chill Month" ;;
 	11 ) TODAYS_MONTH="Ulric Month" ;;
 	12 ) TODAYS_MONTH="Fore-Witching" ;;
 	* ) TODAYS_MONTH="Biamin Festival" ;;  # rarely happens, if ever :(
    esac
    # Adjust year
    case ${TODAYS_YEAR} in
	1 | 21 | 31 | 41 | 51 | 61 | 71 | 81 | 91 ) TODAYS_YEAR+="st";;
	2 | 22 | 32 | 42 | 52 | 62 | 72 | 82 | 92 ) TODAYS_YEAR+="nd";;
	3 | 23 | 33 | 43 | 53 | 63 | 73 | 83 | 93 ) TODAYS_YEAR+="rd";;
	*) TODAYS_YEAR+="th";;
    esac
    # Output example "3rd of Year-Turn in the 13th cycle"
    TODAYS_DATE_STR="$TODAYS_DATE of $TODAYS_MONTH in the $TODAYS_YEAR Cycle"
}

################### MENU SYSTEM #################
MainMenu() {
    while (true) ; do # Forever, because we exit through CleanUp()
	GX_Banner 		
	read -sn 1 -p "      (P)lay      (L)oad game      (H)ighscore      (C)redits      (Q)uit" TOPMENU_OPT # CENTERED to 79px
	case "$TOPMENU_OPT" in
	    p | P ) GX_Banner ;
		    read -p " Enter character name (case sensitive): " CHAR ;
		    [[ "$CHAR" ]] && BiaminSetup;; # Do nothing if CHAR is empty
	    l | L ) LoadGame && BiaminSetup;;      # Do nothing if LoadGame return 1
	    h | H ) HighScore ;;
	    c | C ) Credits ;;
	    q | Q ) CleanUp ;;
	esac
    done
}

HighscoreRead() {
    sort -g -r "$HIGHSCORE" -o "$HIGHSCORE"
    local HIGHSCORE_TMP=" #;Hero;EXP;Wins;Items;Entered History\n;"
    local i=0
    # Read values from highscore file (BashFAQ/001)
    while IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR; do
	(( ++i > 10 )) && break # i++ THEN check (( i > 10 )) 
	case "$highRACE" in
	    1 ) highRACE="Human" ;;
	    2 ) highRACE="Elf" ;;
	    3 ) highRACE="Dwarf" ;;
	    4 ) highRACE="Hobbit" ;;
	esac
	HIGHSCORE_TMP+=" $i.;$highCHAR the $highRACE;$highEXP;$highKILLS/$highBATTLES;$highITEMS/8;$highMONTH $highDATE ($highYEAR)\n"
    done < "$HIGHSCORE"
    echo -e "$HIGHSCORE_TMP" | column -t -s ";" # Nice tabbed output!
    unset HIGHSCORE_TMP
}

HighScore() { # Used in MainMenu()
    GX_HighScore
    echo ""
    # Show 10 highscore entries or die if $HIGHSCORE is empty
    [[ -s "$HIGHSCORE" ]] && HighscoreRead || echo -e " The highscore list is unfortunately empty right now.\n You have to play some to get some!"
    echo -e "\n                   Press the any key to go to (M)ain menu" # CENTERED to 79px
    read -sn 1 
}   # Return to MainMenu()

Credits() { # Used in MainMenu()
    GX_Credits
    read -sn 1 -p "             (H)owTo             (L)icense             (M)ain menu" "CREDITS_OPT" # CENTERED to 79px
    case "$CREDITS_OPT" in
	L | l ) License ;;
	H | h ) GX_HowTo ;;
    esac
    unset CREDITS_OPT
}   # Return to MainMenu()

PrepareLicense() { # gets licenses and concatenates into "LICENSE" in $GAMEDIR
    echo " Downloading GNU GPL Version 3 ..."
    if [[ $(which wget 2>/dev/null) ]]; then # Try wget first
	wget -q -O gpl-3.0.txt "http://www.gnu.org/licenses/gpl-3.0.txt"
	GPL=$(cat gpl-3.0.txt)
	echo "Downloading CC BY-NC-SA 4.0 ..."
	wget -q -O legalcode.txt "http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.txt"
	CC=$(cat legalcode.txt)
    elif [[ $(which curl 2>/dev/null) ]]; then # If no wget try curl
	GPL=$(curl -s "http://www.gnu.org/licenses/gpl-3.0.txt" || "")
	echo "Downloading CC BY-NC-SA 4.0 ..."
	CC=$(curl -s "http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.txt" || "")
    fi
    # Concatenate files into LICENSE file and remove extra files
    if [[ $GPL && $CC ]] ; then 
	echo -e "\t\t   BACK IN A MINUTE BASH CODE LICENSE:\t\t\t(Q)uit\n
$HR
$GPL
\n$HR\n\n\t\t   BACK IN A MINUTE ARTWORK LICENSE:\n\n
$CC"  > "$GAMEDIR/LICENSE"
	echo " Licenses downloaded and concatenated!"
	[[ -f "$GAMEDIR/gpl-3.0.txt" ]] && rm -f "$GAMEDIR/gpl-3.0.txt"     # if wget was used
	[[ -f "$GAMEDIR/legalcode.txt" ]] && rm -f "$GAMEDIR/legalcode.txt" # if wget was used
	sleep 1
	return 0
    else
	echo "Couldn't download the license files :( Do you have Internet access?"
	sleep 1
	return 1
    fi
}

ShowLicense() { # Used in License()
    if [ -z "$PAGER" ] ; then
	echo -en "\n License file available at $GAMEDIR/LICENSE\n Press any key to continue...  " && read -sn 1
    else
	"$PAGER" "$GAMEDIR/LICENSE"
    fi
}
License() { # Used in Credits()
    # Displays license if present or runs PrepareLicense && then display it..
    GX_BiaminTitle
    if [ -z "$PAGER" ] ; then
	if [[ $(which less 2>/dev/null) ]]; then # try less
	    PAGER=$(which less)                
	elif [[ $(which more 2>/dev/null) ]]; then # or try more
	    PAGER=$(which more)
	fi
    fi # or PAGER remains unset (see ShowLicense() in case PAGER is unset)
    if [ -f "$GAMEDIR/LICENSE" ]; then
	ShowLicense
    else
	echo -e "\n License file currently missing in $GAMEDIR/ !"
	read -p " To DL licenses, about 60kB, type YES (requires internet access): " "DL_LICENSE_OPT"
	case "$DL_LICENSE_OPT" in
	    YES ) PrepareLicense && ShowLicense ;;
	    *   ) read -sn 1 -p "
Code License: <http://www.gnu.org/licenses/gpl-3.0.txt>
Art License:  <http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.txt>
More info:    <${WEBURL}about#license>

               Press any key to go back to main menu!" ;; # I've removed \t for 80x24 compability #kstn
	esac
    fi
}   # Return to Credits() 

LoadGame() { # Used in MainMenu()
    local i=0 # Count of all sheets. We could use ${#array_name[@]}, but I'm not sure if MacOS'll understand that. So let's invent bicycle!
    for loadSHEET in $(find "$GAMEDIR"/ -name '*.sheet' | xargs ls -t) ; do # Find all sheets, sort by date and add to array if any
	SHEETS[((++i))]="$loadSHEET" # $i++ THAN initialize SHEETS[$i]. ${SHEETS[0]} is always empty - we'll need it later
    done
    if [[ ! ${SHEETS[@]} ]] ; then # If no one sheet was found
	GX_LoadGame
	read -sn 1 -p " Sorry! No character sheets in ${GAMEDIR}/
Press any key to return to (M)ain menu and try (P)lay" # St. Anykey - patron of cyberneticists :)
	return 1   # BiaminSetup() will not be run after LoadGame()
    fi  # leave
    local LIMIT=9
    local OFFSET=0
    while (true) ; do
	GX_LoadGame
	for (( a=1; a <= LIMIT ; a++)); do
	    [[ ! ${SHEETS[((a + OFFSET))]} ]] && break
	    awk '{ # Character can consist from two and more words - not only "Corum" but "Corum Jhaelen Irsei" for instance 
                   if (/^CHARACTER:/)  { RLENGTH = match($0,/: /);
                  	                 CHARACTER = substr($0, RLENGTH+2); }
                   if (/^RACE:/)       { if ($2 == 1 ) { RACE="Human"; }
               		                 if ($2 == 2 ) { RACE="Elf"; }
             		                 if ($2 == 3 ) { RACE="Dwarf"; }
            		                 if ($2 == 4 ) { RACE="Hobbit";} 
                                        }
                   if (/^LOCATION:/)   { LOCATION = $2 }
                   if (/^HEALTH:/)     { HEALTH = $2 }
                   if (/^ITEMS:/)      { ITEMS = $2 }
                   if (/^EXPERIENCE:/) { EXPERIENCE = $2 }
                 }
                 END { 
                 print " "'$a' ". \"" CHARACTER "\" the " RACE " (" HEALTH " HP, " EXPERIENCE " EXP, " ITEMS " items, sector " LOCATION ")" 
                 }' ${SHEETS[((a + OFFSET))]} 
	done
	(( i > LIMIT)) && echo -en "\n You have more than $LIMIT characters. Use (P)revious or (N)ext to list," # Don't show it if there are chars < LIMIT
	echo -e "\n Enter NUMBER of character to load or any letter to return to (M)ain Menu: "
	read -sn 1 NUM
	case "$NUM" in
	    n | N ) ((OFFSET + LIMIT < i)) && ((OFFSET += LIMIT)) ;; # Next part of list
	    p | P ) ((OFFSET > 0))         && ((OFFSET -= LIMIT)) ;; # Previous part of list
	    [1-9] ) NUM=$((NUM + OFFSET)); break;;                   # Set NUM == selected charsheet num
	    *     ) NUM=0; break;; # Unset NUM to prevent fall in [[ ! ${SHEETS[$NUM]} ]] if user press ESC, KEY_UP etc. ${SHEETS[0]} is always empty
	esac
    done
    if [[ ! ${SHEETS[$NUM]} ]] ; then
	unset NUM SHEETS i
	return 1 # BiaminSetup() will not be run after LoadGame()
    else
	CHAR=$(awk '{if (/^CHARACTER:/) { RLENGTH = match($0,/: /); print substr($0, RLENGTH+2);}}' ${SHEETS[$NUM]} );
	unset NUM SHEETS i
	return 0 # BiaminSetup() will be run after LoadGame()
    fi
}   # return to MainMenu()

# GAME ITEMS
# Randomizers for Item Positions
ITEM_YX() { # Used in HotzonesDistribute() and GX_Map()
    RollDice 15
    ITEM_Y=$DICE
    RollDice 18
    ITEM_X=$DICE
}

HotzonesDistribute() { # Used in Intro() and ItemWasFound()
    # Scatters special items across the map
    local MAP_X;
    local MAP_Y;
    read -r MAP_X MAP_Y  <<< $(awk '{ print substr($0, 1 ,1); print substr($0, 2); }' <<< "$CHAR_GPS")
    MAP_X=$(awk '{print index("ABCDEFGHIJKLMNOPQR", $0)}' <<< "$MAP_X") # converts {A..R} to {1..18}
    ITEMS_2_SCATTER=$(( 8 - CHAR_ITEMS ))
    HOTZONE=() # Reset HOTZONE  
    while (( ITEMS_2_SCATTER > 0 )) ; do
	ITEM_YX # Randomize ITEM_X and ITEM_Y
	(( ITEM_X ==  MAP_X )) && (( ITEM_Y == MAP_Y )) && continue         # reroll if HOTZONE == CHAR_GPS
	[[ $(grep -E "(^| )$ITEM_X-$ITEM_Y( |$)" <<< "${HOTZONE[@]}") ]] && continue # reroll if "$ITEM_X-$ITEM_Y" is already in ${HOTZONE[@]}
	HOTZONE[((--ITEMS_2_SCATTER))]="$ITEM_X-$ITEM_Y" # --ITEMS_2_SCATTER, than init ${HOTZONE[ITEMS_2_SCATTER]},
	# --ITEMS_2_SCATTER - because array starts from ${HOTZONE[0]}
    done
}

################### GAME SYSTEM #################
RollDice() {     # Used in RollForEvent(), RollForHealing(), etc
    DICE_SIZE=$1 # DICE_SIZE used in RollForEvent()
    RANDOM=$(date '+%N') # Reseed random number generator
    DICE=$((RANDOM%$DICE_SIZE+1))
}

## GAME FUNCTIONS: ITEMS IN LOOP
ItemWasFound() { # Used in NewSector()
    case "$CHAR_ITEMS" in
	0 ) GX_Item0 ;;				# Gift of Sight (set in MapNav)
	1 ) (( HEALING++ )) && GX_Item1 ;;	# Emerald of Narcolepsy (set now & setup)
	2 ) GX_Item2 ;;				# Guardian Angel (set in battle loop)
	3 ) (( FLEE++ )) && GX_Item3 ;;         # Fast Magic Boots (set now & setup)
	4 ) GX_Item4 ;;				# Quick Rabbit Reaction (set in battle loop)
	5 ) GX_Item5 ;;				# Flask of Terrible Odour (set in battle loop)
	6 ) (( STRENGTH++ )) && GX_Item6 ;;	# Two-Handed Broadsword	(set now & setup)
	7 | *) (( ACCURACY++ )) && GX_Item7 ;;	# Steady Hand Brew (set now & setup)
    esac

    local COUNTDOWN=180
    while (( COUNTDOWN > 0 )); do
	GX_Item$CHAR_ITEMS
	echo "                      Press any letter to continue  ($COUNTDOWN)"
	read -sn 1 -t 1 && COUNTDOWN=-1 || ((COUNTDOWN--))
    done
    # Re-distribute items to increase randomness if char haven't all 8 items.
    (( ++CHAR_ITEMS < 8 )) && HotzonesDistribute # Increase CHAR_ITEMS , THEN check (( CHAR_ITEMS < 8 ))    
    SaveCurrentSheet # Save CHARSHEET items
    NODICE=1         # No fighting if item is found..
}   # Return to NewSector()

## GAME ACTION: MAP + MOVE
MapNav() { # Used in NewSector()
    if [ -z "$1" ] ; then	# If empty = toggle map (m) was pressed, else just move!
	GX_Map
	# If COLOR==0, YELLOW and RESET =="" so string'll be without any colors
	echo -en " ${YELLOW}o ${CHAR}${RESET} is currently in $CHAR_GPS"

	case "$SCENARIO" in
	    H ) echo " (Home)" ;;
	    x ) echo " (Mountain)" ;;
	    . ) echo " (Road)" ;;
	    T ) echo " (Town)" ;;
	    @ ) echo " (Forest)" ;;
	    C ) echo " (Oldburg Castle)" ;;
	esac

	echo "$HR"
	read -sn 1 -p " I want to go  (W) North  (A) West  (S)outh  (D) East  (Q)uit :  " DEST
    else  # The player did NOT toggle map, just moved without looking from NewSector()..
	DEST="$1"
	GX_Place "$SCENARIO"    # Shows the _current_ scenario scene, not the destination's.
    fi

    case "$DEST" in # Fix for 80x24: \e[1K - erase to the start of line \e[80D - move cursor 80 columns backward. Dirty but better than nothing #kstn
	w | W | n | N ) echo -n "You go North"; # Going North (Reversed: Y-1)
	    (( MAP_Y != 1  )) && (( MAP_Y-- )) || ( echo -en "\e[1K\e[80DYou wanted to visit Santa, but walked in a circle.." && sleep 3 ) ;;
	d | D | e | E ) echo -n "You go East" # Going East (X+1)
	    (( MAP_X != 18 )) && (( MAP_X++ )) || ( echo -en "\e[1K\e[80DYou tried to go East of the map, but walked in a circle.." && sleep 3 ) ;;
	s | S ) echo -n "You go South" # Going South (Reversed: Y+1)
	    (( MAP_Y != 15 )) && (( MAP_Y++ )) || ( echo -en "\e[1K\e[80DYou tried to go someplace warm, but walked in a circle.." && sleep 3 ) ;;
	a | A ) echo -n "You go West" # Going West (X-1)
	    (( MAP_X != 1  )) && (( MAP_X-- )) || ( echo -en "\e[1K\e[80DYou tried to go West of the map, but walked in a circle.." && sleep 3 ) ;;
	q | Q ) CleanUp ;; # Save and exit
	* ) echo -n "Loitering.." && sleep 2
    esac

    MAP_X=$(awk '{print substr("ABCDEFGHIJKLMNOPQR", '$MAP_X', 1)}' <<< "$MAP_X") # Translate MAP_X numeric back to A-R
    CHAR_GPS="$MAP_X$MAP_Y" 	# Set new [A-R][1-15] to CHAR_GPS
    sleep 1
}   # Return NewSector()

# GAME ACTION: DISPLAY CHARACTER SHEET
DisplayCharsheet() { # Used in NewSector() and FightMode()
    # kill/fight percentage
    (( CHAR_KILLS > 0 )) && MURDERSCORE=$(bc <<< "scale=zero; (100 * $CHAR_KILLS ) / $CHAR_BATTLES") || MURDERSCORE=0
    case $CHAR_RACE in
	1 ) local RACE="(Human)" ;;
	2 ) local RACE="(Elf)" ;;
	3 ) local RACE="(Dwarf)" ;;
	4 ) local RACE="(Hobbit)" ;;
    esac
    case "$SCENARIO" in
	H ) local PLACE="(Home)" ;; 
	x ) local PLACE="(Mountain)" ;;
	. ) local PLACE="(Road)" ;;
	T ) local PLACE="(Town)" ;;
	@ ) local PLACE="(Forest)" ;;
	C ) local PLACE="(Oldburg Castle)" ;;
    esac
    GX_CharSheet
    cat <<EOF
 Character:                 $CHAR $RACE
 Health Points:             $CHAR_HEALTH
 Experience Points:         $CHAR_EXP
 Current Location:          $CHAR_GPS $PLACE
 Current Date:              $TODAYS_DATE_STR
 Number of Battles:         $CHAR_BATTLES
 Enemies Slain:             $CHAR_KILLS ($MURDERSCORE%)
 Items found:               $CHAR_ITEMS of 8
 Special Skills:            Healing $HEALING, Strength $STRENGTH, Accuracy $ACCURACY, Flee $FLEE
 
EOF
	read -sn 1 -p "        (D)isplay Race Info        (A)ny key to continue        (Q)uit"  CHARSHEET_OPT  # CENTERED to 79px
	case "$CHARSHEET_OPT" in
		d | D ) GX_Races && read -sn1 -p "                          Press any letter to return" ;;    
		q | Q ) CleanUp ;;
	esac
}

FightTable() {  # Used in FightMode()
    GX_Monster_"$ENEMY"
    echo -e "$SHORTNAME\t\tHEALTH: $CHAR_HEALTH\tStrength: $STRENGTH\tAccuracy: $ACCURACY" | tr '_' ' '
    echo -e "$ENEMY_NAME\t\t\tHEALTH: $EN_HEALTH\tStrength: $EN_STRENGTH\tAccuracy: $EN_ACCURACY\n" # added \n here..!
}   # Return to FightMode()

EchoFightFormula() { # Display Formula in Fighting. Used in FightMode()
    # req.: dice-size | formula | skill-abbrevation
    local DICE_SIZE="$1"
    local FORMULA="$2"
    local SKILLABBREV="$3"

    if (( DICE_SIZE <= 9 )) ; then
	echo -n "Roll D$DICE_SIZE "
    else
	echo -n "Roll D$DICE_SIZE"
    fi

    case "$FORMULA" in
	eq )    echo -n " = " ;;
	gt )    echo -n " > " ;;
	lt )    echo -n " < " ;;
	ge )    echo -n " >=" ;;
	le )    echo -n " <=" ;;
	times ) echo -n " x " ;;
    esac

    # skill & roll
    echo -n " $SKILLABBREV ( "
    # The actual symbol in $DICE vs eg $CHAR_ACCURACY is already
    # determined in the if and cases of the Fight Loop, so don't repeat here.
}

FightMode() {	# FIGHT MODE! (secondary loop for fights)
                # Used in NewSector() and Rest()
    LUCK=0      # Used to assess the match in terms of EXP..
    FIGHTMODE=1	# Anti-cheat bugfix for CleanUp: Adds penalty for CTRL+C during fights!

    RollDice 20 # Determine enemy type    
    case "$SCENARIO" in
	H ) ENEMY="chthulu" ;; 
	x ) (( DICE <= 10 )) && ENEMY="orc"     || (( DICE >= 16 )) && ENEMY="goblin" || ENEMY="varg" ;;
	. ) (( DICE <= 12 )) && ENEMY="goblin"  || ENEMY="bandit" ;;
	T ) (( DICE <= 15 )) && ENEMY="bandit"  || ENEMY="mage"   ;;
	@ ) (( DICE <=  8 )) && ENEMY="goblin"  || (( DICE >= 17 )) && ENEMY="orc"    || ENEMY="bandit" ;;
	C ) (( DICE <=  5 )) && ENEMY="chthulu" || ENEMY="mage" ;;
    esac

    # SET ENEMY ATTRIBUTES
    # EN_FLEE_THRESHOLD - At what Health will enemy flee? :)
    # PL_FLEE_EXP       - Exp player get if he manage to flee from enemy
    # EN_FLEE_EXP       - Exp player get if enemy manage to flee from him
    # EN_DEFEATED_EXP   - Exp player get if he manage to kill the enemy

    case "$ENEMY" in
	bandit )  EN_STRENGTH=2 ; EN_ACCURACY=4 ; EN_FLEE=7 ; EN_HEALTH=30  ; EN_FLEE_THRESHOLD=18 ; PL_FLEE_EXP=5   ; EN_FLEE_EXP=10  ; EN_DEFEATED_EXP=20   ;;
	goblin )  EN_STRENGTH=3 ; EN_ACCURACY=3 ; EN_FLEE=5 ; EN_HEALTH=30  ; EN_FLEE_THRESHOLD=15 ; PL_FLEE_EXP=10  ; EN_FLEE_EXP=15  ; EN_DEFEATED_EXP=30   ;; 
	orc )     EN_STRENGTH=4 ; EN_ACCURACY=4 ; EN_FLEE=4 ; EN_HEALTH=80  ; EN_FLEE_THRESHOLD=40 ; PL_FLEE_EXP=15  ; EN_FLEE_EXP=25  ; EN_DEFEATED_EXP=50   ;; 
	varg )    EN_STRENGTH=4 ; EN_ACCURACY=3 ; EN_FLEE=3 ; EN_HEALTH=80  ; EN_FLEE_THRESHOLD=60 ; PL_FLEE_EXP=25  ; EN_FLEE_EXP=50  ; EN_DEFEATED_EXP=100  ;;
	mage )    EN_STRENGTH=5 ; EN_ACCURACY=3 ; EN_FLEE=4 ; EN_HEALTH=90  ; EN_FLEE_THRESHOLD=45 ; PL_FLEE_EXP=35  ; EN_FLEE_EXP=75  ; EN_DEFEATED_EXP=150  ;;
	chthulu ) EN_STRENGTH=6 ; EN_ACCURACY=5 ; EN_FLEE=1 ; EN_HEALTH=500 ; EN_FLEE_THRESHOLD=35 ; PL_FLEE_EXP=200 ; EN_FLEE_EXP=500 ; EN_DEFEATED_EXP=1000 ;;
    esac

    ENEMY_NAME=$(awk '{ print substr(toupper($0), 1,1) substr($0, 2); }' <<< "$ENEMY") # Capitalize enemy to Enemy for FightTable()

    GX_Monster_$ENEMY
    sleep 1

    # Adjustments for items
    (( CHAR_ITEMS >= 5 )) && (( ACCURACY++ )) # item4: Quick Rabbit Reaction
    (( CHAR_ITEMS >= 6 )) && (( EN_FLEE++ ))  # item5: Flask of Terrible Odour

    if (( EN_ACCURACY > ACCURACY )); then # DETERMINE INITIATIVE (will usually be enemy)
	echo "The $ENEMY has initiative"
	NEXT_TURN="en"
    else
	echo "$CHAR has the initiative!"
	NEXT_TURN="pl" 
    fi

    sleep 2

    (( CHAR_ITEMS >= 5 )) && (( ACCURACY--)) # Resets Quick Rabbit Reaction setting..

    # GAME LOOP: FIGHT LOOP
    while (( FIGHTMODE > 0 )) # If player didn't manage to run
    do
	if (( CHAR_HEALTH <= 0 )); then
	    FightTable # for 80x24 compability
	    echo "Your health points are $CHAR_HEALTH"
	    sleep 2
	    echo "You WERE KILLED by the $ENEMY, and now you are dead..."
	    sleep 2
	    if (( CHAR_EXP >= 1000 )) && (( CHAR_HEALTH > -15 )); then    
		echo "However, your $CHAR_EXP Experience Points relates that you have"
		echo "learned many wondrous and magical things in your travels..!"
		(( CHAR_HEALTH += 20 ))
		echo "+20 HEALTH: Health restored by 20 points (HEALTH: $CHAR_HEALTH)"
		LUCK=2
		sleep 8
	    elif (( CHAR_ITEMS >= 3 )) && (( CHAR_HEALTH > -5 )); then
		echo "Suddenly you awake again, SAVED by your Guardian Angel!"
		echo "+5 HEALTH: Health restored by 5 points (HEALTH: $CHAR_HEALTH)"
		(( CHAR_HEALTH += 5 ))
		LUCK=2
		sleep 8
	    else      # DEATH!
		echo "Gain 1000 Experience Points to achieve magic healing!"
		sleep 4
		case "$CHAR_RACE" in
		    1 ) FUNERAL_RACE="human" ;;
		    2 ) FUNERAL_RACE="elf" ;;
		    3 ) FUNERAL_RACE="dwarf" ;;
		    4 ) FUNERAL_RACE="hobbit" ;;
		esac
		local COUNTDOWN=20
		while (( COUNTDOWN > 0 )); do
		    GX_Death
		    echo " The $TODAYS_DATE_STR:"
		    echo " In such a short life, this sorry $FUNERAL_RACE gained $CHAR_EXP Experience Points."
		    echo " We honor $CHAR with $COUNTDOWN secs silence." 
    		    read -sn 1 -t 1 && COUNTDOWN=-1 || ((COUNTDOWN--))
		done
		unset FUNERAL_RACE COUNTDOWN
		echo "$CHAR_EXP;$CHAR;$CHAR_RACE;$CHAR_BATTLES;$CHAR_KILLS;$CHAR_ITEMS;$TODAYS_DATE;$TODAYS_MONTH;$TODAYS_YEAR" >> "$HIGHSCORE"
		rm -f "$CHARSHEET" # A sense of loss is important for gameplay :)
		unset CHARSHEET CHAR CHAR_RACE CHAR_HEALTH CHAR_EXP CHAR_GPS SCENARIO CHAR_BATTLES CHAR_KILLS CHAR_ITEMS
		DEATH=1 
	    fi
	    unset FIGHTMODE 
	    break # Zombie fix for all variants of death and resurrection
	fi

	FightTable

	case "$NEXT_TURN" in
	    pl )  # Player's turn
		echo -n "It's your turn, press (A)ny key to (R)oll or (F) to Flee " 
		read -sn 1 "FIGHT_PROMPT"
		FightTable
		if [[ "$FIGHT_PROMPT" == "f" || "$FIGHT_PROMPT" == "F" ]] ; then # Player tries to flee!
		    RollDice 6
		    EchoFightFormula 6 le F
		    unset FIGHT_PROMPT
		    if (( DICE <= FLEE )); then
			(( DICE == FLEE )) && echo -n "$DICE =" || echo -n "$DICE <"
			echo -n " $FLEE ) You try to flee the battle .."
			sleep 2
			FightTable
			RollDice 6
			EchoFightFormula 6 le eA
			if (( DICE <= EN_ACCURACY )); then
			    (( DICE == FLEE )) && echo -n "$DICE =" || echo -n "$DICE <"
			    echo -n " $EN_ACCURACY ) The $ENEMY blocks your escape route!"
			    sleep 1
			else # Player managed to flee
			    echo -n "$DICE > $EN_ACCURACY ) You managed to flee!"
			    unset FIGHTMODE
			    LUCK=3
			    break
			fi
		    else
			echo -n "$DICE > $FLEE ) Your escape was unsuccessful!"
		    fi
		else # Player fights
		    RollDice 6
   		    EchoFightFormula 6 le A		# test-implementation of EchoFightFormulat
		    unset FIGHT_PROMPT
		    if (( DICE <= ACCURACY )); then
			(( DICE == ACCURACY )) && echo -n "$DICE = $ACCURACY" || echo -n "$DICE < $ACCURACY"
			echo -n " ) Your weapon hits the target!"
			echo -e "\nPress the R key to (R)oll for damage"
			read -sn 1 "FIGHT_PROMPT"
			RollDice 6
			EchoFightFormula 6 times S
			DAMAGE=$(( DICE * STRENGTH ))
			echo -n "$DICE x $STRENGTH ) Your blow dishes out $DAMAGE damage points!"
			(( EN_HEALTH -= DAMAGE ))
			(( EN_HEALTH <= 0 )) && unset FIGHTMODE && sleep 4 && break
		    else
			echo -n "$DICE > $ACCURACY ) You missed!"
		    fi
		fi 
		NEXT_TURN="en"
		sleep 3
		;;
	    en ) # Enemy's turn
		if (( EN_HEALTH < EN_FLEE_THRESHOLD )) && (( EN_HEALTH < CHAR_HEALTH )); then # Enemy tries to flee
		    FightTable
		    RollDice 20
		    echo "Rolling for enemy flee .. ( D20 < eF )"		    
		    sleep 2
		    if (( DICE < EN_FLEE )); then
			EchoFightFormula 20 lt eF
			echo "$DICE < $EN_FLEE ) The $ENEMY uses an opportunity to flee!"
			LUCK=1
			unset FIGHTMODE
			sleep 2
			break # bugfix: Fled enemy continue fighting..
		    fi
		    FightTable # If enemy didn't managed to flee
		fi
		echo "It's the $ENEMY's turn"
		sleep 2
		RollDice 6
		EchoFightFormula 6 le eA
		if (( DICE <= EN_ACCURACY )); then
		    (( DICE == EN_ACCURACY )) && echo -n "$DICE = $EN_ACCURACY" || echo -n "$DICE < $EN_ACCURACY"
		    echo " ) The $ENEMY strikes you!"
		    sleep 1
		    RollDice 6
		    EchoFightFormula 6 times eS
		    DAMAGE=$(( DICE * EN_STRENGTH ))
		    #    -en used here to avoid "jumping" from >24 blocks in terminal
		    echo -en "$DICE x $EN_STRENGTH ) The $ENEMY's blow hits you with $DAMAGE points! [-$DAMAGE HP]" 
		    (( CHAR_HEALTH -= DAMAGE ))
		    SaveCurrentSheet
		else
		    echo "$DICE > $EN_ACCURACY ) The $ENEMY misses!"
		fi
		NEXT_TURN="pl"
		sleep 3		
		;;
	esac
    done # FIGHT LOOP ends

    # After the figthing 
    if (( DEATH != 1 )) ; then   # VICTORY!
	if (( LUCK == 2 )); then   # died but saved by guardian angel or 1000 EXP
	    echo "When you come to, the $ENEMY has left the area ..."
	elif (( LUCK == 1 )); then # ENEMY managed to FLEE
	    echo -n "You defeated the $ENEMY and gained $EN_FLEE_EXP Experience Points!" 
	    (( CHAR_EXP += EN_FLEE_EXP ))
	elif (( LUCK == 3 )); then # PLAYER managed to FLEE during fight!
	    echo -e "\nYou got away while the $ENEMY wasn't looking, gaining $PL_FLEE_EXP Experience Points!"
	    (( CHAR_EXP += PL_FLEE_EXP ))
	else			   # ENEMY was slain!
	    FightTable
	    echo "You defeated the $ENEMY and gained $EN_DEFEATED_EXP Experience Points!" 
	    (( CHAR_EXP += EN_DEFEATED_EXP ))
	    (( CHAR_KILLS++ ))
	fi
	(( CHAR_BATTLES++ ))
	SaveCurrentSheet
	unset LUCK
	sleep 4
	DisplayCharsheet
    fi  # else exit after CheckForDeath() in NewSector()
}   # Return to NewSector() or to Rest()


# GAME ACTION: REST
RollForHealing() { # Used in Rest()
    RollDice 6
    echo -e "Rolling for healing: D6 <= $HEALING\nROLL D6: $DICE"
    (( DICE > HEALING )) && echo "$2" || { (( CHAR_HEALTH += $1 )) ; echo "You slept well and gained $1 Health." ;}
    sleep 2
}   # Return to Rest()

# GAME ACTION: REST
# Game balancing can also be done here, if you think players receive too much/little health by resting.
Rest() {  # Used in NewSector()
    RollDice 100
    GX_Rest
    case "$SCENARIO" in
	H ) if (( CHAR_HEALTH < 100 )); then
		CHAR_HEALTH=100
		echo "You slept well in your own bed. Health restored to 100."
	    else
		echo "You slept well in your own bed, and woke up to a beautiful day."
	    fi
	    sleep 2 ;;
	x ) RollForEvent 60 && FightMode || RollForHealing 5  "The terrors of the mountains kept you awake all night.." ;;
	. ) RollForEvent 30 && FightMode || RollForHealing 10 "The dangers of the roads gave you little sleep if any.." ;;
	T ) RollForEvent 15 && FightMode || RollForHealing 15 "The vices of town life kept you up all night.." ;;
	@ ) RollForEvent 35 && FightMode || RollForHealing 5  "Possibly dangerous wood owls kept you awake all night.." ;;
	C ) RollForEvent 5  && FightMode || RollForHealing 35 "Rowdy castle soldiers on a drinking binge kept you awake.." ;;
    esac
    sleep 2
}   # Return to NewSector()

# THE GAME LOOP

RollForEvent() { # Used in NewSector() and Rest()
    echo -e "Rolling for event: D${DICE_SIZE} <= $1\nD${DICE_SIZE}: $DICE" 
    sleep 2
    (( DICE <= $1 )) && return 0 || return 1
}   # Return to NewSector() or Rest()

GX_Place() {     # Used in NewSector() and MapNav()
    case "$1" in # Display scenario GFX
	H ) GX_Home ;;
	x ) GX_Mountains ;;
	. ) GX_Road ;;
	T ) GX_Town ;;
	@ ) GX_Forest ;;
	C ) GX_Castle ;;
        * ) CustomMapError;;
    esac
}   # Return to NewSector() or MapNav()

# THE GAME LOOP
NewSector() { # Used in Intro()
    while (true) # While (player-is-alive) :) 
    do
	# Find out where we are - fixes LOCATION in CHAR_GPS "A1" to a place on the MapNav "X1,Y1"
	read -r MAP_X MAP_Y  <<< $(awk '{ print substr($0, 1 ,1); print substr($0, 2); }' <<< "$CHAR_GPS")
	MAP_X=$(awk '{print index("ABCDEFGHIJKLMNOPQR", $0)}' <<< "$MAP_X") # converts {A..R} to {1..18} #kstn
	# MAP_Y+2 MAP_X+2 - padding for borders
	SCENARIO=$(awk '{ if ( NR == '$((MAP_Y+2))') { print $'$((MAP_X+2))'; }}' <<< "$MAP" )
	# Look for treasure @ current GPS location  - checks current section for treasure
	(( CHAR_ITEMS < 8 )) && [[ $(grep -E "(^| )$MAP_X-$MAP_Y( |$)" <<< "${HOTZONE[@]}") ]] && ItemWasFound

	if [[ $NODICE ]] ; then # Do not attack player at the first turn of after finding item
	    unset NODICE 
	else
	    GX_Place "$SCENARIO"
	    RollDice 100        # Find out if we're attacked 
	    case "$SCENARIO" in # FightMode() if RollForEvent return 0
		H ) RollForEvent 1  && FightMode ;;
		x ) RollForEvent 50 && FightMode ;;
		. ) RollForEvent 20 && FightMode ;;
		T ) RollForEvent 15 && FightMode ;;
		@ ) RollForEvent 35 && FightMode ;;
		C ) RollForEvent 10 && FightMode ;;
		* ) CustomMapError ;;
	    esac
	    (( DEATH == 1 )) && break	# Break if player was slain
	fi
	
	while (true); do # GAME ACTIONS MENU BAR
	    GX_Place "$SCENARIO"
	    echo -n "        (C)haracter        (R)est        (M)ap and Travel        (Q)uit" # CENTERED to 79px
	    read -sn 1 ACTION
	    case "$ACTION" in
		c | C ) DisplayCharsheet ;;
		r | R ) Rest; # Player may be attacked during the rest :)
		        (( DEATH == 1 )) && break 2 ;; # If player was slain during the rest
		q | Q ) CleanUp ;;              # Leaving the realm of magic behind ....
		m | M ) MapNav; break ;;        # Go to Map then move
		* ) MapNav "$ACTION"; break ;;	# Move directly (if not WASD, then loitering :)
	    esac
	done
    done # Player is dead
    unset DEATH
    HighScore
}   # Return to MainMenu() (if player is dead)

Intro() { # Used in BiaminSetup()
    # Intro function basically gets the game going
    # Create capitalized FIGHT CHAR name
    SHORTNAME=$(awk '{ STR = $0;
                       if (length(STR) > 12) { STR = substr(STR,0,12); }
                       else { LEN = 12 - length(STR); for (i=0; i < LEN; i++) { STR = STR "_" } }
                       print substr(toupper(STR), 1,1) substr(STR, 2); }' <<< "$CHAR")
    TodaysDate	       # Fetch today's date in Warhammer calendar (Used in DisplayCharsheet() and FightMode() )
    MapCreate          # Create session map in $MAP  
    (( CHAR_ITEMS < 8 )) && HotzonesDistribute # Place items randomly in map
    local COUNTDOWN=60
    GX_Intro
    echo "                        Press any letter to continue" 
    while (( COUNTDOWN >= 0 )); do
    	read -sn 1 -t 1 && COUNTDOWN=-1 || ((COUNTDOWN--))
    done
    unset COUNTDOWN
    
    NODICE=1 # Do not roll on first section after loading/starting a game in NewSector()
    NewSector
}

Announce() { # Simply outputs a 160 char text you can cut & paste to social media.
    SetupHighscore
    # Die if $HIGHSCORE is empty
    [ ! -s "$HIGHSCORE" ] && Die "Sorry, can't do that just yet!\nThe highscore list is unfortunately empty right now."

    echo "TOP 10 BACK IN A MINUTE HIGHSCORES"
    HighscoreRead
    echo -en "\nSelect the highscore (1-10) you'd like to display or CTRL+C to cancel: "
    read SCORE_TO_PRINT

    (( SCORE_TO_PRINT < 1 )) && (( SCORE_TO_PRINT > 10 )) && Die "\nOut of range. Please select an entry between 1-10. Quitting.."

    RollDice 6
    case $DICE in
	1 ) ADJECTIVE="honorable" ;;
	2 ) ADJECTIVE="fearless" ;;
	3 ) ADJECTIVE="courageos" ;;
	4 ) ADJECTIVE="brave" ;;
	5 ) ADJECTIVE="legendary" ;;
	6 ) ADJECTIVE="heroic" ;;
    esac

    ANNOUNCEMENT_TMP=$(sed -n "${SCORE_TO_PRINT}"p "$HIGHSCORE")
    IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR <<< "$ANNOUNCEMENT_TMP"

    case $highRACE in
	1 ) highRACE="Human" ;;
	2 ) highRACE="Elf" ;;
	3 ) highRACE="Dwarf" ;;
	4 ) highRACE="Hobbit" ;;
    esac

    (( highBATTLES == 1 )) && highBATTLES+=" battle" || highBATTLES+=" battles"
    (( highITEMS == 1 ))   && highITEMS+=" item"     || highITEMS+=" items"

    highCHAR=$(awk '{ print substr(toupper($0), 1,1) substr($0, 2); }' <<< "$highCHAR") # Capitalize
    ANNOUNCEMENT="$highCHAR fought $highBATTLES, $highKILLS victoriously, won $highEXP EXP and $highITEMS. This $ADJECTIVE $highRACE was finally slain the $highDATE of $highMONTH in the $highYEAR Cycle."
    
    GX_HighScore

    echo "ADVENTURE SUMMARY to copy and paste to your social media of choice:"
    echo -e "\n$ANNOUNCEMENT\n" | fmt
    echo "$HR"

    ANNOUNCEMENT_LENGHT=$(awk '{print length($0)}' <<< "$ANNOUNCEMENT" ) 
    (( ANNOUNCEMENT_LENGHT > 160 )) && echo "Warning! String longer than 160 chars ($ANNOUNCEMENT_LENGHT)!"
}

ColorConfig() {
    echo -en "
We need to configure terminal colors for the map!
Please note that a colored symbol is easier to see on the world map.
Back in a minute was designed for white text on black background.
Does \033[1;33mthis text appear yellow\033[0m without any funny characters?
Do you want color? No to DISABLE, Yes or ENTER to ENABLE color: " 
    read COLOR_CONFIG
    case "$COLOR_CONFIG" in
	N | n | NO | No | no | DISABLE | disable ) 
	    COLOR=0 ; echo "Disabling color! Edit $GAMEDIR/config to change this setting." ;;
	* ) COLOR=1 ; echo "Enabling color!" ;;
    esac
    sed -i"~" "s/COLOR: NA/COLOR: $COLOR/g" "$GAMEDIR/config" # MacOS fix http://stackoverflow.com/questions/7573368/in-place-edits-with-sed-on-os-x
    sleep 2
}

CreateBiaminLauncher() {
    grep -q 'biamin' "$HOME/.bashrc" && Die "Found existing launcher in $HOME/.bashrc.. skipping!" 
    BIAMIN_RUNTIME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # $0 is a powerful beast, but will sometimes fail..
    echo "This will add $BIAMIN_RUNTIME/biamin to your .bashrc"
    read -n 1 -p "Install Biamin Launcher? [Y/N]: " LAUNCHER
    case "$LAUNCHER" in
	y | Y ) echo -e "\n# Back in a Minute Game Launcher (just run 'biamin')\nalias biamin='$BIAMIN_RUNTIME/biamin.sh'" >> "$HOME/.bashrc" ;
	        echo -e "\nDone. Run 'source \$HOME/.bashrc' to test 'biamin' command." ;;
	* ) echo -e "\nDon't worry, not changing anything!";;
    esac
}        

#                           END FUNCTIONS                              #
#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                                                                      #
#                        2. RUNTIME BLOCK                              #
#                   All running code goes here!                        #

# Parse CLI arguments if any
case "$1" in
    --announce ) Announce ; exit 0 ;;
    -h | --help )
	echo "Run BACK IN A MINUTE with '-p', '--play' or 'p' argument to play!"
	echo "For usage: run biamin --usage"
	echo "Current dir for game files: $GAMEDIR/"
	echo "Change at runtime or on line 10 in the CONFIGURATION of the script."
	exit 0;;
    -i | --install ) CreateBiaminLauncher ; exit 0 ;;
    --map ) read -n1 -p "Create custom map template? [Y/N] " CUSTOM_MAP_PROMPT
	case "$CUSTOM_MAP_PROMPT" in
		y | Y) echo -e "\nCreating custom map template.." && MapCreateCustom ;;
		*)     echo -e "\nNot doing anything! Quitting.."
	esac
	exit 0 ;;
    -p | --play | p ) echo "Launching Back in a Minute.." ;;
    -v | --version )
	echo "BACK IN A MINUTE VERSION $VERSION Copyright (C) 2014 Sigg3.net"
	echo "Game SHELL CODE released under GNU GPL version 3 (GPLv3)."
	echo "This is free software: you are free to change and redistribute it."
	echo "There is NO WARRANTY, to the extent permitted by law."
	echo "For details see: <http://www.gnu.org/licenses/gpl-3.0>"
	echo "Game ARTWORK released under Creative Commons CC BY-NC-SA 4.0."
	echo "You are free to copy, distribute, transmit and adapt the work."
	echo "For details see: <http://creativecommons.org/licenses/by-nc-sa/4.0/>"
	echo "Game created by Sigg3. Submit bugs & feedback at <$WEBURL>"
	exit 0 ;;
    --update ) # Updater for LEGACY
    # Removes stranded repo files before proceeding..
	STRANDED_REPO_FILES=$(find "$GAMEDIR"/repo.* | wc -l)
	if (( STRANDED_REPO_FILES >= 1 )); then
		rm -f "$GAMEDIR/repo.*"
	fi
	REPO_SRC="https://gitorious.org/back-in-a-minute/$REPO_EDITION/raw/biamin.sh"
	GX_BiaminTitle;
	sed 's/https:\/\///' <<< "Retrieving $REPO_SRC .."
	REPO=$( mktemp $GAMEDIR/repo.XXXXXX ) 
	if [[ $(which wget 2>/dev/null) ]]; then # Try wget, automatic redirect
	    wget -q -O "$REPO" "$REPO_SRC" || Die "DOWNLOAD ERROR: No internet with wget"
	elif [[ $(which curl 2>/dev/null) ]]; then # Try curl, -L - for redirect
	    curl -s -L -o "$REPO" "$REPO_SRC" || Die  "DOWNLOAD ERROR: No internet with curl"
	else
	    Die "DOWNLOAD ERROR: No curl or wget available"
	fi

	REPO_VERSION=$( sed -n -r '/^VERSION=/s/^VERSION="([^" ]*) .*".*$/\1/p' "$REPO" )
	CURRENT_VERSION=$( sed -r 's/^([^" ]*) .*$/\1/' <<< "$VERSION")
	echo "Your current Back in a Minute game is version ${VERSION}"
	# Compare versions $1 and $2. Versions should be [0-9]+.[0-9]+.[0-9]+. ... 
	if [[ "$CURRENT_VERSION" == "$REPO_VERSION" ]] ; then
	    RETVAL=0 
	else
	    IFS="\." read -a VER1 <<< "$CURRENT_VERSION"
	    IFS="\." read -a VER2 <<< "$REPO_VERSION"
	    for ((i=0; ; i++)); do # until break
		[[ ! "${VER1[$i]}" ]] && { RETVAL=2; break; } # REPO_VERSION > VERSION
		[[ ! "${VER2[$i]}" ]] && { RETVAL=1; break; } # VERSION > REPO_VERSION
		(( ${VER1[$i]} > ${VER2[$i]} )) && { RETVAL=1; break; } # VERSION > REPO_VERSION
		(( ${VER1[$i]} < ${VER2[$i]} )) && { RETVAL=2; break; } # REPO_VERSION > VERSION
	    done
	    unset VER1 VER2
	fi
	case "$RETVAL" in
	    0)  echo "This is the latest version ($VERSION) of Back in a Minute!" ; rm -f "$REPO";;
	    1)  echo "Your version ($VERSION) is newer than $REPO_VERSION" ; rm -f "$REPO";;
	    2)  echo "Newer version $REPO_VERSION is available!"
		echo "Updating will NOT destroy character sheets, highscore or current config."
 		read -sn1 -p "Update to Biamin version $REPO_VERSION? [Y/N] " CONFIRMUPDATE
		case "$CONFIRMUPDATE" in
		    y | Y ) echo -e "\nUpdating Back in a Minute from $VERSION to $REPO_VERSION .."
			# TODO make it less ugly
			BIAMIN_RUNTIME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # $0 is a powerful beast, but will sometimes fail.
			BIAMIN_RUNTIME+="/"
			BIAMIN_RUNTIME+=$( basename "${BASH_SOURCE[0]}")
			mv "$BIAMIN_RUNTIME" "${BIAMIN_RUNTIME}.bak" # backup current file
			mv "$REPO" "$BIAMIN_RUNTIME"
			chmod +x "$BIAMIN_RUNTIME" || Die "PERMISSION ERROR: Couldnt make biamin executable"
			echo "Run 'sh $BIAMIN_RUNTIME --install' to add launcher!" 
			echo "Current file moved to ${BIAMIN_RUNTIME}.bak" ;;
		    * ) echo -e "\nNot updating! Removing temporary file .."; rm -f "$REPO" ;;
		esac ;;
	esac
	echo "Done. Thanks for playing :)"
	exit 0 ;;
    --usage | * )
	echo "Usage: biamin or ./biamin.sh"
	echo "  (NO ARGUMENTS)      display this usage text and exit"
	echo "  -p --play or p      PLAY the game \"Back in a minute\""
	echo "     --announce       DISPLAY an adventure summary for social media and exit"
	echo "  -i --install        ADD biamin.sh to your .bashrc file"
	echo "     --map            CREATE custom map template with instructions and exit"
	echo "     --help           display help text and exit"
	echo "     --update         check for updates"
	echo "     --usage          display this usage text and exit"
	echo "  -v --version        display version and licensing info and exit"
	exit 0 ;;
esac

if [[ ! -d "$GAMEDIR" ]] ; then # Check whether gamedir exists..
    echo "Game directory default is $GAMEDIR/" ;
    echo "You can change this in $GAMEDIR/config. Creating directory .." ;
    mkdir -p "$GAMEDIR/" || Die "ERROR! You do not have write permissions for $GAMEDIR .."
fi

if [[ ! -f "$GAMEDIR/config" ]] ; then # Check whether $GAMEDIR/config exists..
    echo "Creating $GAMEDIR/config .." ;
    echo -e "GAMEDIR: $GAMEDIR\nCOLOR: NA" > "$GAMEDIR/config" ;
fi

echo "Putting on the traveller's boots.."

# Load variables from $GAMEDIR/config. NB variables should not be empty !
read -r GAMEDIR COLOR <<< $(awk '{ if (/^GAMEDIR:/)  { GAMEDIR= $2 }
                                   if (/^COLOR:/)    { COLOR = $2  } }
                            END { print GAMEDIR " " COLOR ;}' "$GAMEDIR/config" )

case "$COLOR" in # Color configuration
    1 ) echo "Enabling color for maps!" ;;
    0 )	echo "Enabling old black-and-white version!" ;;
    * ) ColorConfig ;;
esac

# Define colors if enabled
if (( COLOR == 1 )); then
    YELLOW='\033[1;33m' # Used in MapNav() and GX_Map()
    RESET='\033[0m'
fi

trap CleanUp SIGHUP SIGINT SIGTERM # Direct termination signals to CleanUp

SetupHighscore # Setup highscore file
MainMenu       # Run main menu
exit 0         # This should never happen:
               # .. but why be 'tardy when you can be tidy?
