A bit about the solution reached in Microsoft 365 Excel version 2411.

First, I've created two sheets: one with the rules (`Rules`) and another with the updates (`Updates`).
Then, I've created another sheet called `Part 1`. In this one, I compute whether a number is satifies its own rules.
This is, I check if any of the previous numbers should be _after_ the one I'm checking. This is done with this weird fomula.

```
=IF(
  ISBLANK(Updates!B1); FALSE;
  OR(
    Updates!$A1:A1=FILTER(
      Rules!$B$1:$B$1176;
      Rules!$A$1:$A$1176=Updates!B1;
      0
    )
  )
)
```

I spread this formula in a big grid (A1:W194). After that, for each row I do something simple like "if all elements are
FALSE, then get the middle number". Finally sum.

The `Part 2` was way trickier. The main idea is to "take all the pages of the update, see which one has no dependencies,
put it in place and repeat without this page". The first part of this formula declares an `updates` array which includes
all the elements from the updates except those which has already been placed. The second part computes the number of
dependencies for each page, sorts it, and takes the first page.

```
=IF(ISBLANK(Updates!A1);"";
  LET(
    updates;
    TOCOL(FILTER(
      Updates!$A1:$W1;
      NOT(ISNUMBER(MATCH(Updates!$A1:$W1; TAKE($A1:$W1;;COLUMN()-1); 0)));
      0
    ); 1);


    INDEX(
      SORTBY(
        updates;
        MAP(
          updates;
          LAMBDA(n;
            SUMPRODUCT(
               --(Rules!$B$1:$B$1176=n);
               --ISNUMBER(MATCH(Rules!$A$1:$A$1176; updates; 0))
            )
          )
        );
        1
      );
      1
    )
  )
)
```
