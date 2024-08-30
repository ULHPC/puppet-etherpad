type Etherpad::Ldapauth = Struct[
  {
    Optional['url']                  => String[1],
    Optional['accountBase']          => String[1],
    Optional['accountPattern']       => String[1],
    Optional['displayNameAttribute'] => String[1],
    Optional['searchDN']             => String[1],
    Optional['searchPWD']            => String[1],
    Optional['groupSearchBase']      => String[1],
    Optional['groupAttribute']       => String[1],
    Optional['groupAttributeIsDN']   => Boolean,
    Optional['searchScope']          => String[1],
    Optional['groupSearch']          => String[1],
    Optional['anonymousReadonly']    => Boolean,
  }
]
