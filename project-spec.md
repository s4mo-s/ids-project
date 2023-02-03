# ER diagram a model prípadov použitia

ER diagram zachycuje systém pre vyhľadávanie a rezervovanie miestností. Uživateľ identifikovaný primárnym kľúčom má svoje meno, priezvisko, email, heslo a rolu ( správca/zamestnanec ).
Uživateľ môže zisťovať dostupnosť miestností v danom termíne alebo vytvárať rezervácie na vybranú miestnosť pre skúšky, semináre a iné akcie v daný čas. Taktiež môže vypisovať rozvrh po oboroch, ročníkoch alebo po učebniach.
Každá miestnosť má svoje ID, miesto, kapacitu a vybavenie, o ktorom si vedieme názov, cenu a dátum kúpy. Miestnosť rozdeľujeme na učebňu alebo laboratórium.

### Zadanie: 16. Učebny

Navrhněte systém správy učeben a laboratoří. V systému budou uloženy údaje převzaté z fakultního rozvrhu výuky a údaje o učebnách (místo, kapacita, speciální vybavení). Systém vypisovat rozvrh po oborech a ročnících nebo po učebnách, musí umožnit zjistit volné učebny v daném termínu a vybranou uče, rezervovat vybranou místnost pro zkoušky, semináře a jiné akce, měnit informace o učebnách a rozvrhové informace atd. Rezervace mohou provádět jen zaměstnanci, změny informací o učebnách a laboratořích jen správce systému.
