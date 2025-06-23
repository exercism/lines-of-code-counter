pub impl IgnoreCase of PartialEq<ByteArray> {
    fn eq(lhs: @ByteArray, rhs: @ByteArray) -> bool {
        let len = lhs.len();
        if len != rhs.len() {
            return false;
        }
        let mut i = 0;
        loop {
            if i == len {
                break true;
            }
            if lowercase(@lhs[i]) != lowercase(@rhs[i]) {
                break false;
            }
            i += 1;
        }
    }

    fn ne(lhs: @ByteArray, rhs: @ByteArray) -> bool {
        !IgnoreCase::eq(lhs, rhs)
    }
}

pub fn sort_ignore_case(word: @ByteArray) -> ByteArray {
    // count the number each of the alphabet ASCII characters appears
    let mut ascii_chars: Felt252Dict<u8> = Default::default();
    let mut i = word.len();
    while i != 0 {
        i -= 1;
        let char: felt252 = word[i].into();
        ascii_chars.insert(char, ascii_chars.get(char) + 1);
    };

    let mut sorted_word: ByteArray = "";

    // append each appearing alphabet ASCII character
    let mut alphabet_char: u8 = 65; // char 'A'
    while alphabet_char <= 90 { // char 'Z'
        // process uppercase char
        let mut count = ascii_chars.get(alphabet_char.into());
        while count != 0 {
            sorted_word.append_byte(alphabet_char);
            count -= 1;
        };
        // process lowercase char
        let lowercase_char = alphabet_char + 32;
        let mut count = ascii_chars.get(lowercase_char.into());
        while count != 0 {
            sorted_word.append_byte(lowercase_char);
            count -= 1;
        };

        alphabet_char += 1;
    };

    sorted_word
}

fn lowercase(char: @u8) -> u8 {
    if *char < 97 {
        *char + 32
    } else {
        *char
    }
}
