# PULSE, PASS 3

Opened 14 Sep 2026, Room 8. Everything the King raised while testing pass 1 and pass 2.
Nothing here is built. Pass 1 and pass 2 are live and are in the commit before this file.

---

## 1. THE LOOK. Emily's eye over the whole app.

**What he saw.** On a desktop the Call and WhatsApp buttons stretch the full width of a
card. They were sized for a thumb on a phone and nobody capped them on a wide screen.
The spacing between cards is wrong for the same reason.

**What he asked for, in his words:** premium, not busy. Easy to read and easy to act on,
on a phone and on a desktop, the way any good screen is.

## 2. PULSE BECOMES DR MADHU'S, NOT A GENERIC DASHBOARD.

Rebrand it to the design of drmadhusudan.com, his colours and his fonts, his name on it.

## 3. A TOP NAVIGATION THAT SAYS WHAT EACH SCREEN IS FOR.

Today, Patients, Store, Health mean nothing to somebody opening it the first time. The
navigation should tell them, so the app teaches itself.

## 4. THE NEXT DOCTOR IS A SWAP, NOT A REBUILD.

**This decides how 1, 2 and 3 get written, so they are done together.**
Colours, fonts, the clinic name and the logo live in one block at the top of the file.
Change those four things and it is another doctor's Pulse. The King wants to sell this
again and never rebuild it.

## 5. "PAID BY" HAS TO LOOK LIKE A CHOICE.

**It already captures UPI, Card, Online link and Not paid yet.** The fault is that it is
greyed out and resting on Cash, so it reads as a fixed label and nobody opens it. The
King himself read it as cash only. If he misread it, reception will too.

## 6. WHAT HAPPENED, ON AN ORDER NOBODY PAID FOR.

Today those cards carry a Call and a WhatsApp button and record nothing. Two people can
ring the same man and neither knows.

**We can never know whether a WhatsApp message was delivered or read.** That needs a
WhatsApp Business account wired to us, which the clinic does not have. What we can record
is that somebody worked him, and what came of it.

**Four buttons, no more. His instruction.**
Did not pick up · Will pay, sent the link · Changed his mind · Wrong number.
Plus a stamp on the card: who rang, and when.

## 7. WHEN A PAID ORDER GOES WRONG.

A paid order has three buttons: packed, sent, delivered. There is nothing for the three
things that actually go wrong. **Cancelled · Came back · Address is wrong.** The database
already accepts cancelled; the screen has no button for it.

## 8. TWO LOGINS, AND ONE KEY PER CLINIC.

Ritesh's ask, 2 Sep: stop making a login per person, make one per clinic. Only two clinics
are open, Kalkaji and Gurgaon.

- Team key: everything except money.
- Dr Madhu and us: everything, including revenue.
- The purple Opportunities box stays ours and is never on his key. It names weak spots in
  his own clinic in our words, and that is something Akash says to him himself.
- Names are picked from a list, never created. **Sohail Khan (Kalkaji) and Khushi
  (Gurgaon) are not on that list yet.** Rajkumar is, as backup for both.

## 9. THE RESULTS SCREEN. HIS TOP PRIORITY.

**Why it matters, in his words:** when Dr Madhu pays us he should look at this screen and
feel that something real is being done. Revenue and views are both what we sell.

**Three money figures, kept apart, never added together by accident.**

| Source | Broken down by |
|---|---|
| Walk-in, the clinic floor | clinic |
| Funnels | funnel, with paid ads and organic marked plainly |
| Store | medicine |

Draw the split. Keep the views beside the money.

**The number nobody is showing him.** Since the desk started recording on 2 September,
ten days, walk-ins have brought **₹3,13,437**. Every funnel since June has brought
**₹2,14,684**. The clinic floor is out-earning everything online and his screen buries it
in one grey line.

**The empty bucket is not a capture fault.** The shop has genuinely never taken a rupee.
The only thin one is "Other": ₹272 from 5 payments, and it stopped in July.

**And the money sitting there untouched, which is the argument for Pulse itself:**
76 people due a reorder · 217 never called once · 1,500 to 2,000 clinic patients never
entered at all.

**Name.** He left it to us. Candidates: Results, Performance, Money. Short enough for the
bottom bar.

## 10. THE WALK-IN MIGRATION, AND THE CRM QUESTION.

**The CRM he is asking for already exists.** It is the Patients tab: 497 people, leads and
paying customers in one table, each tagged with the door they came through.

**What is missing is the history.** We hold 63 people from the clinic floor, 26 walk-ins
and 37 phone enquiries, and the oldest is 31 August. Two weeks. Everything before that is
not in there. Meanwhile the desk recorded 100 visits worth ₹3.13 lakh in ten days, so the
money is captured and the people behind the older money are not.

**The method when the file arrives.** Match on the last ten digits of the phone, which is
already how a shop order finds an existing patient, so a man who bought online and also
walked in becomes one person and not two. Load in batches of fifty. Show what matched and
what is new before a single row is written.

**The blocker is not ours.** Manish has to send the sheet, September included. It has been
the blocker on `madhu-migrate-walkins` since 21 August.

## 11. THE TODAY SCREEN CARRIES A GLANCE AT THE NUMBERS.

Added 14 Sep while he tested pass 1.

Today is a list of jobs and nothing else. He wants a small piece of the Results screen
sitting on it, so opening the app answers "what happened today" before he has to go
looking. Money taken today, where it came from, drawn as a share rather than typed out.

**Keep it to one block.** The whole complaint about the app today is that it is cluttered
and does not feel premium, so this cannot become another wall of numbers. One glance,
then the list of jobs underneath it.

**Depends on item 9,** because it is the same numbers read from the same place.

---

## WHAT IS STILL UNPROVEN, AND ONLY A REAL PAYMENT PROVES IT

No order has ever been paid for. So the chain built on 14 September has never once run:
a paid order becoming a patient at Delivery, and marking the parcel delivered starting his
reorder call. Every piece tests clean on its own. The one rupee product in the catalogue
settles it in five minutes.
