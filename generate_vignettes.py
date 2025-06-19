import pandas as pd
import random

TEMPLATES = {
    "intentionalist_low": (
        "{agent} realizó una acción sabiendo que existía un {prob}% de que exactamente {damage} personas inocentes resultaran dañadas. Lo hizo {motivation}."
    ),
    "intentionalist_high": (
        "{agent} actuó con incertidumbre: la probabilidad de causar daño estaba entre {prob_low}% y {prob_high}% y podrían verse afectadas entre {damage_low} y {damage_high} personas. El motivo principal fue {motivation}."
    ),
    "consequentialist_low": (
        "La decisión de {agent} generará con un {prob}% de certeza exactamente {damage} víctimas. No se menciona la intención de la persona, solo el resultado esperado."
    ),
    "consequentialist_high": (
        "{agent} eligió un curso de acción con resultados inciertos: entre {prob_low}% y {prob_high}% de probabilidad de provocar entre {damage_low} y {damage_high} víctimas. No se describen sus estados mentales, solo las consecuencias."
    ),
}

AGENTS = ["Alex", "Jamie", "Jordan", "Sam", "Casey", "Taylor", "Morgan", "Avery"]
MOTIVATIONS = [
    "para evitar un mal mayor",
    "porque debía seguir órdenes",
    "para proteger a alguien cercano",
]
PROB_LOW = [60, 80, 95]
PROB_HIGH_RANGES = [(40, 60), (60, 80)]
DAMAGE_LOW = [1, 3, 5]
DAMAGE_HIGH_RANGES = [(1, 3), (3, 7)]
ROWS_PER_CELL = 50


def generate_row(framework: str, ambiguity: str, idx: int) -> dict:
    agent = random.choice(AGENTS)
    motivation = random.choice(MOTIVATIONS)

    if ambiguity == "low":
        prob = random.choice(PROB_LOW)
        damage = random.choice(DAMAGE_LOW)
        text = TEMPLATES[f"{framework}_low"].format(
            agent=agent, prob=prob, damage=damage, motivation=motivation
        )
        return {
            "ID": idx,
            "Framework": framework,
            "Ambiguity": ambiguity,
            "Agent": agent,
            "Prob": f"{prob}%",
            "ProbRange": None,
            "Damage": damage,
            "DamageRange": None,
            "Motivation": motivation,
            "Text": text,
        }
    else:
        prob_low, prob_high = random.choice(PROB_HIGH_RANGES)
        damage_low, damage_high = random.choice(DAMAGE_HIGH_RANGES)
        text = TEMPLATES[f"{framework}_high"].format(
            agent=agent,
            prob_low=prob_low,
            prob_high=prob_high,
            damage_low=damage_low,
            damage_high=damage_high,
            motivation=motivation,
        )
        return {
            "ID": idx,
            "Framework": framework,
            "Ambiguity": ambiguity,
            "Agent": agent,
            "Prob": None,
            "ProbRange": f"{prob_low}%–{prob_high}%",
            "Damage": None,
            "DamageRange": f"{damage_low}-{damage_high}",
            "Motivation": motivation,
            "Text": text,
        }


def main():
    rows = []
    idx = 1
    for _ in range(ROWS_PER_CELL):
        rows.append(generate_row("intentionalist", "low", idx))
        idx += 1
    for _ in range(ROWS_PER_CELL):
        rows.append(generate_row("intentionalist", "high", idx))
        idx += 1
    for _ in range(ROWS_PER_CELL):
        rows.append(generate_row("consequentialist", "low", idx))
        idx += 1
    for _ in range(ROWS_PER_CELL):
        rows.append(generate_row("consequentialist", "high", idx))
        idx += 1

    df = pd.DataFrame(rows)
    df.to_csv("vignettes.csv", index=False)


if __name__ == "__main__":
    main()
