import pandas as pd
import random
from pathlib import Path


PARTICIPANT_DIR = Path("participant_csvs")
PARTICIPANT_DIR.mkdir(exist_ok=True)


def sample_vignettes(df: pd.DataFrame, framework: str, ambiguity: str, n: int):
    subset = df[(df["Framework"] == framework) & (df["Ambiguity"] == ambiguity)]
    return subset.sample(n, replace=False)


def main():
    df = pd.read_csv("vignettes.csv")

    for pid in range(1, 201):
        random.seed(pid)
        ilow = sample_vignettes(df, "intentionalist", "low", 2)
        ihigh = sample_vignettes(df, "intentionalist", "high", 2)
        clow = sample_vignettes(df, "consequentialist", "low", 2)
        chigh = sample_vignettes(df, "consequentialist", "high", 2)

        participant_rows = pd.concat([ilow, ihigh, clow, chigh]).sample(frac=1).reset_index(drop=True)
        file_name = PARTICIPANT_DIR / f"participant_{pid:03d}.csv"
        participant_rows.to_csv(file_name, index=False)


if __name__ == "__main__":
    main()
