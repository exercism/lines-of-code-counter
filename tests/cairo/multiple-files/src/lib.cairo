use anagram::helper::{IgnoreCase, sort_ignore_case};

#[derive(Drop, Debug)]
struct Set {
    values: Array<ByteArray>
}

#[generate_trait]
pub impl SetImpl of SetTrait {
    fn new(values: Array<ByteArray>) -> Set {
        Set { values }
    }
}

impl SetEq of PartialEq<Set> {
    fn eq(lhs: @Set, rhs: @Set) -> bool {
        let len = lhs.values.len();
        if len != rhs.values.len() {
            return false;
        }
        let mut i = 0;
        loop {
            if i == len {
                break true;
            }
            let l_item = lhs.values.at(i);
            let mut j = 0;
            while j != len {
                if IgnoreCase::eq(l_item, rhs.values.at(j)) {
                    break;
                }
                j += 1;
            };
            if j == len {
                break false;
            }
            i += 1;
        }
    }

    fn ne(lhs: @Set, rhs: @Set) -> bool {
        !(lhs == rhs)
    }
}

pub fn anagrams_for(word: @ByteArray, inputs: @Set) -> Set {
    let mut word_sorted = @sort_ignore_case(word);
    let mut anagrams = Set { values: array![] };
    let mut i = inputs.values.len();

    while i != 0 {
        i -= 1;
        let candidate = inputs.values[i];

        let is_anagram = word.len() == candidate.len()
            && IgnoreCase::ne(word, candidate)
            && IgnoreCase::eq(word_sorted, @sort_ignore_case(candidate));

        if is_anagram {
            anagrams.values.append(format!("{candidate}"));
        }
    };

    anagrams
}

mod helper;
