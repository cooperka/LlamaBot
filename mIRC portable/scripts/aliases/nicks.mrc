;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/afk {
  if ($1) { nick Coopkev|AFK| $+ $1- | away Away from keyboard: $1- | tipoff }
  else { nick Coopkev|AFK | away Away from keyboard... | tipoff }
}

/afh {
  if ($1) { nick Coopkev|AFH| $+ $1- | away Away from home: $1- | tipoff }
  else { nick Coopkev|AFH | away Away from home... | tipoff }
}

/brb {
  if ($1) { nick Coopkev|BRB| $+ $1- | away Be right back: $1- | tipoff }
  else { nick Coopkev|BRB | away I should be back soon... | tipoff }
}

/nik { /nick Coopkev| $+ $1- }

/bi { nick Coopkev|BI $+ $1 | away Be back in about $1 minute(s). | tipoff }

/qz { nick Coopkev|Quasi | away Not really paying attention... }
/quasi { nick Coopkev|Quasi | away Not really paying attention... }
/quazi { nick Coopkev|Quasi | away Not really paying attention... }

/hw { nick Coopkev|HW | away Doing homework... }

/java { nick Coopkev|Java | away Programming in Java... }

/xl { nick Coopkev|AFK|xL | away Playing Xbox Live... | tipoff }

/setwa { nick Coopkev|wA | away Doing a WebAssign... }

/bn { nick Coopkev|AFK|BN | away Eating breakfast... | tipoff }
/ln { nick Coopkev|AFK|LN | away Eating lunch... | tipoff }
/dn { nick Coopkev|AFK|DN | away Eating dinner... | tipoff }

/ctg { nick Coopkev|AFK|CTG | away Cutting the grass... | tipoff }
/grass { nick Coopkev|AFK|CTG | away Cutting the grass... | tipoff }

/raking { nick Coopkev|AFK|Rake | away Raking the lawn... | tipoff }
/rake { nick Coopkev|AFK|Rake | away Raking the lawn... | tipoff }

/shovel { nick Coopkev|AFK|Snow | away Shovelling snow... | tipoff }
/snow { nick Coopkev|AFK|Snow | away Shovelling snow... | tipoff }

/blend { nick Coopkev|Blend | away Using Blender... }
/blender { nick Coopkev|Blend | away Using Blender... }

/back {
  nick Coopkev | away | tipon | %backSpCh = 1 | .timerBackSpCh 1 60 unset %backSpCh
  if (%joinNotice) { joinoff }
}
/bck { back }
/bcak { back }
/abck { back }

/imback {
  if ($chan !isin %notlist) {
    if ($awaytime > 3600) { msg $chan I'm back (Gone for $floor($calc($awaytime / 3600)) $+ h : $floor($calc(($awaytime % 3600) / 60)) $+ m : $calc($awaytime % 60) $+ s) }
    else if ($awaytime > 60) { msg $chan I'm back (Gone for $floor($calc($awaytime / 60)) $+ m : $calc($awaytime % 60) $+ s) }
    else { msg $chan I'm back (Gone for $awaytime seconds) }
  }
  else {
    if ($awaytime > 3600) { echo 4 -a I'm back (Gone for $floor($calc($awaytime / 3600)) $+ h : $floor($calc(($awaytime % 3600) / 60)) $+ m : $calc($awaytime % 60) $+ s) }
    else if ($awaytime > 60) { echo 4 -a I'm back (Gone for $floor($calc($awaytime / 60)) $+ m : $calc($awaytime % 60) $+ s) }
    else { echo 4 -a I'm back (Gone for $awaytime seconds) }
  }
  back
}

/WMW /nick MWMMWMMWMMWMMWMMWMMWMMWMMWMMWM
/MWM /nick MWMMWMMWMMWMMWMMWMMWMMWMMWMMWM
/b0t /nick LlamaB0T

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
