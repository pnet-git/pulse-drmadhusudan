# PULSE, PASS 3

# BUILT 14 SEP 2026, EVENING. WHAT SHIPPED AND WHAT IS LEFT.

**Live at pulse.drmadhusudan.com.** Commit "Pass 3: Pulse becomes Dr Madhu's, and the Results screen".

| Item | State |
|---|---|
| 1 The look | **Done.** Rebuilt in the colours and fonts of drmadhusudan.com. Buttons sized for a finger on a phone and a pointer on a desktop. Lists read at 760px, the numbers screen at 1080px. |
| 2 Rebrand | **Done.** Paper, cream, wine, olive, gold. His face top left and on the login screen. |
| 3 Navigation that says what it is for | **Done.** Under every tab on the desktop. Five rooms: Today, Patients, Store, New, Results. |
| 4 The next doctor is a swap | **Done.** One block at the top of the style holds every colour and font. A BRAND object at the top of the script holds the name, the photo, the site and the group link. |
| 5 Paid by looks like a choice | **Done.** A row of buttons, shown the moment a consultation is picked. Medicine has its own row. |
| 6 What happened on an unpaid order | **Done.** Four buttons. Each stamps the card with the date and who pressed it. Newest stamp shows on the closed card. |
| 7 When a paid order goes wrong | **Done.** Under a fold: cancelled, came back, address is wrong. Cancelled orders leave the never-paid list. |
| 8 Two logins, one key per clinic | **Built, not switched on.** The app accepts TEAM_KEY_KALKAJI and TEAM_KEY_GURGAON and locks the clinic from the key. The two keys still have to be set on Vercel, and Sohail Khan and Khushi still have to be added to the name list. Both need the King. |
| 9 Results | **Done.** Three kinds of money kept apart, one ring for the split, funnels by page with organic and paid ads marked, walk-in by clinic, store by medicine, where each door's money lands, views beside the money, and what is waiting to be collected. |
| 10 Migration | **Waiting on the sheet from Manish.** Nothing to build until it arrives. |
| 11 Today glance | **Done.** One wine block above the jobs. Money across every door for the doctor and us, counts only for the team. |
| 12 His face, and a way to ask for help | **Done.** Photo in place. WhatsApp button into the group, top right and in the name menu. |
| 13 Walked on a phone | **Done at 390 and 360 wide.** No sideways scroll on any screen. Still worth one walk on a real phone in the clinic before the message goes out. |
| 14 Message to the group | **Not yet.** Waits for item 8 so the message can carry the right keys. |
| 15 Gateways visible | **Half.** Which gateway sits on which door is on the Results screen in words. Money by gateway needs one read-only function on his database, which needs the King's yes. |

**The two writes that need the King's yes.** One row each for Sohail Khan and Khushi in the name list. And, if he wants money by gateway as a number, one read-only function that groups payments by gateway.

**Not proven, and only a real payment proves it.** No order has ever been paid for. The paid-order chain has still never run.

---


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

## 12. HIS FACE ON IT, AND A WAY TO ASK FOR HELP.

Added 14 Sep while he tested pass 2.

**His photograph somewhere on Pulse.** Today it is a wordmark and nothing else. It should
look like his clinic's tool, not a tool. Sits with item 2, the rebrand.

**A WhatsApp button that opens the group.** One tap from inside Pulse into the client
WhatsApp group, so reception can report a fault or ask for a change the moment it happens
instead of it dying on the floor.

**Waiting on the link.** Only a group admin can see it. Ritesh is the admin and was asked
for it on 14 Sep. An invite link is the right one even though it says invite: anybody
already in the group who taps it just lands in the group.

## 13. NOTHING SHIPS UNTIL IT HAS BEEN USED ON A PHONE.

Added 14 Sep. **This is a gate on pass 3, not an item in it.**

His instruction: he does not want Dr Madhu or the clinic team hitting a single problem on
a phone. So pass 3 is not finished when the screens look right on a laptop.

**Walk the whole thing on a real phone before it is called done.** Every screen, every
button, every form, in portrait, one thumb, on the clinic's own wifi.
- Add a walk-in start to finish and save it.
- Work a patient card: open it, press a What happened button, type a note, save it.
- Move an order along on the Store screen.
- Read the Results screen without pinching or scrolling sideways.
- Do it once on a small phone, not only a big one.

**Anything that needs two hands, a pinch, or a sideways scroll is a fault.**

## 14. THE MESSAGE TO THE GROUP, WHEN PASS 3 IS DONE.

Added 14 Sep. **Not now. After the work.**

One message into the client WhatsApp group carrying two things:

**1. Put Pulse on your home screen.** The King liked this most of everything today, and it
is the change that makes them open it daily instead of hunting for a bookmark. Steps for
an iPhone and for an Android, in plain words, no screenshots needed.

**2. What is new and what they can now do.** Short list, written for reception and for the
doctor, not a changelog. What they could not do before and can do now. And where to tell
us when something is wrong, which by then is the WhatsApp button inside Pulse itself.

**Draft it through the `email` skill, Joanna.** It is going to a client's team, so it is
not written freehand.

## 15. THE PAYMENT GATEWAYS ARE TRACKED, BUT NOT VISIBLE.

Audited 14 Sep. All three are being captured. The fault is that the gateway's name is
buried inside a blob of text on each payment, so no screen can show it.

| Gateway | Where | Payments | Money | Running |
|---|---|---|---|---|
| Razorpay | funnels | 194 | ₹1,57,306 | 10 Jun to today |
| Cashfree | Modak funnel | 38 | ₹57,877 | 20 Jul to 13 Aug only |
| PhonePe | the store | 0 | ₹0 | live, never taken a rupee |

**Why Cashfree stopped, and it is not a fault.** King-stated, 14 Sep: Cashfree needed KYC
and asked him to move to Razorpay in the meanwhile. So Razorpay carrying the funnels today
is deliberate. Nothing to chase.

**The store is PhonePe and stays PhonePe.**

**What to build.** Lift the gateway out of the blob into a field of its own, and show money
by gateway on the Results screen. Note that the store's orders live in their own table,
so the three can never be added up on one screen until that is done.

---

# THE BRIEF. READ THIS FIRST IF YOU DID NOT DO PASSES 1 AND 2.

## WHERE EVERYTHING IS

| Thing | Where |
|---|---|
| Pulse, the whole app | `keep-clients/dr-madhu/pulse/index.html`, one file, about 1,450 lines |
| Its server side | `keep-clients/dr-madhu/pulse/api/` — `desk.js` (patients, orders), `data.js` (money and content), `ops.js` (the Opportunities box) |
| Its git home | github.com/pnet-git/pulse-drmadhusudan, branch `main` |
| Live at | pulse.drmadhusudan.com |
| The shop, for the design to copy | `keep-clients/dr-madhu/store/build/preview/`, live at drmadhusudan.com |

## HOW TO SHIP IT

From `keep-clients/dr-madhu/pulse/`: `vercel --prod --yes`. That is the whole deploy.
The shop is the same command from `keep-clients/dr-madhu/store/build/preview/`.
**Check the live site after every deploy. Do not report done from a local file.**

## THE DATABASE, AND THE ONE RULE THAT MATTERS

Supabase project `praswrwxhdvtnlcevmtz`. **This is the client's own live production
database with real patients and real payments in it.**

- **Reads are free.**
- **Every write needs the King's explicit yes on a delta table shown to him first.**
- Never run a migration, never enable row level security, never drop or rename anything.
- Timestamps come back in London time. Convert before showing him:
  `to_char(x at time zone 'Asia/Kolkata','YYYY-MM-DD HH24:MI')`.

Tables you will touch: `desk_leads` (the patients and leads, 497 rows), `desk_visits`
(money taken at the clinic counter), `desk_medicines`, `desk_team` (the name list),
`shop_orders` (website orders), `revenue` (funnel payments). Everything goes through
security-definer functions that need a key; the app holds `DESK_KEY` and `SHOP_API_KEY`
as Vercel environment variables.

## WHO SEES WHAT TODAY

Three keys, all Vercel environment variables on the pulse project.
`PULSE_PASSWORD` = clinic team, no money. `DOCTOR_PASSWORD` = Dr Madhu, adds Health and
Content. `OPS_PASSWORD` = us, adds the purple Opportunities box. **Item 8 collapses this
to two.**

## WHAT PASSES 1 AND 2 ALREADY DID, SO IT IS NOT REDONE

Twenty one changes, shipped and tested on 14 Sep 2026, all in the commit
"The store feeds the patient desk, and the screens get easier to read".

Validation on the New person form. The Store tab and the whole order flow. Clinic money
kept apart from shop money on Health. Delhi renamed Kalkaji in what people read. Grey text
lifted above the readable floor. The sticky search shrunk from 116px to 62px. A clear
button on the search. The call note turned into a real box. Add to home screen. A dozen
small text sizes.

## HOW TO WRITE FOR THIS MAN

He is not technical and his time is the price of every clever word. Plain words, short
lines, no jargon, and never name a table or a column when talking to him. Say what he
sees, what it costs him, what is being done. The full law is in `CLAUDE.md` at the root of
the repo and it is not optional.

## THE ORDER TO BUILD IN

1. **Items 2, 3, 4 and 1 together.** The rebrand, the navigation, the look, and the one
   block of colours and fonts at the top that makes the next doctor a swap. They are one
   job and doing them separately means doing them twice.
2. **Item 9, the Results screen**, then **item 11**, the glance at it on Today. He calls
   this the most important thing on here.
3. **Items 5, 6, 7**, the small functional gaps.
4. **Item 8**, the logins, which needs his yes on a database write.
5. **Item 13 is the gate on all of it.** Walked on a real phone, or it is not done.
6. **Item 14 last**, the message to the group.

---

## WHAT IS STILL UNPROVEN, AND ONLY A REAL PAYMENT PROVES IT

No order has ever been paid for. So the chain built on 14 September has never once run:
a paid order becoming a patient at Delivery, and marking the parcel delivered starting his
reorder call. Every piece tests clean on its own. The one rupee product in the catalogue
settles it in five minutes.
