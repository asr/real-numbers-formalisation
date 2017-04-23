module Distance where

open import AbsoluteValue
open import Axioms
open import EqReasoning
open import EqProperties
open import Logic
open import Nat
open import Properties

-- Previous properties.

x-y<0→x<y : {x y : ℝ} → x - y < r₀ → x < y
x-y<0→x<y {x} {y} h = p₁-helper (p₂-helper (>-to-< (>-+-right h)) )

  where
   p₁-helper : x + r₀ < y → x < y
   p₁-helper h₁ = subst₂ (λ t₁ t₂ → t₁ > t₂) (refl y) (+-neut x) h₁

   p₂-helper : x - y + y < r₀ + y → x + r₀ < y
   p₂-helper h₂ = subst₂ (λ t₁ t₂ → t₁ > t₂) p₂₁-helper p₂₂-helper h₂

    where
     p₂₁-helper : r₀ + y ≡ y
     p₂₁-helper =
        r₀ + y ≡⟨ +-comm r₀ y ⟩
        y + r₀ ≡⟨ +-neut y ⟩
        y      ∎

     p₂₂-helper : x - y + y ≡ x + r₀
     p₂₂-helper =
        x - y + y     ≡⟨ +-asso x (- y) y ⟩
        x + (- y + y) ≡⟨ subst (λ w → x + (- y + y) ≡ x + w) (+-comm (- y) y) (refl (x + (- y + y))) ⟩
        x + (y - y)   ≡⟨ subst (λ w → x + (y - y) ≡ x + w) (+-inve y) (refl (x + (y - y))) ⟩
        x + r₀       ∎
-x<0→x>0 : (x : ℝ) → - x < r₀ → x > r₀
-x<0→x>0 x -x<0 = <-to-> (x-y<0→x<y p₁-helper)

  where
   p₁-helper : r₀ - x < r₀
   p₁-helper = subst₂ (λ t₁ t₂ → t₁ < t₂) p₂-helper (refl r₀) -x<0

    where
     p₂-helper : - x ≡ r₀ - x
     p₂-helper =
        - x      ≡⟨ ≡-sym (+-neut (- x)) ⟩
        - x + r₀ ≡⟨ +-comm (- x) r₀ ⟩
        r₀ - x   ∎

≤→≯  : {x y : ℝ} → x ≤ y → x ≯ y
≤→≯ {x} {y} x≤y x>y = case prf1 prf2 x≤y

  where
    prf1 : x < y → ⊥
    prf1 x<y = <-asym x<y (>-to-< x>y)

    prf2 : x ≡ y → ⊥
    prf2 x≡y = >→≢ x>y x≡y

-x=0→x=0 : (x : ℝ) → - x ≡ r₀ → x ≡ r₀
-x=0→x=0 x -x=0 = ≡-*-cancel-r (<→≢(x>0→-x<0 1>0)) p-helper

  where
   p-helper : x * - r₁ ≡ r₀ * - r₁
   p-helper =
     x * - r₁   ≡⟨ *-comm x (- r₁) ⟩
     - r₁ * x   ≡⟨ mul-xy ⟩
     - (r₁ * x) ≡⟨ subst (λ w → - (r₁ * x) ≡ - w) (*-comm r₁ x) (refl (- (r₁ * x))) ⟩
     - (x * r₁) ≡⟨ subst (λ w → - (x * r₁) ≡ - w) (*-neut x) (refl (- (x * r₁))) ⟩
     - x        ≡⟨ -x=0 ⟩
     r₀         ≡⟨ ≡-sym *-right-zero ⟩
     - r₁ * r₀  ≡⟨ *-comm (- r₁) r₀ ⟩
     r₀ * - r₁      ∎

x-y=0→x=y : (x y : ℝ) → x - y ≡ r₀ → x ≡ y
x-y=0→x=y x y h =
     x             ≡⟨ ≡-sym (+-neut x) ⟩
     x + r₀        ≡⟨ subst (λ w → x + r₀ ≡ x + w) (≡-sym (+-inve y)) (refl (x + r₀)) ⟩
     x + (y - y)   ≡⟨ subst (λ w → x + (y - y) ≡ x + w) (+-comm y (- y)) (refl (x + (y - y))) ⟩
     x + (- y + y) ≡⟨ ≡-sym (+-asso x (- y) y) ⟩
     (x - y) + y   ≡⟨ subst (λ w → (x - y) + y ≡ w + y) h (refl ((x - y) + y)) ⟩
     r₀ + y        ≡⟨ +-comm r₀ y ⟩
     y + r₀        ≡⟨ +-neut y ⟩
     y      ∎

-- Distance (or metric) between two points.
-- Mathematical Analysis. Apostol, Tom. M. 1974. Pag. 60.

dist : ℝ → ℝ → ℝ
dist x y = abs (x - y)

d-refl : (x y : ℝ) → (dist x y ≡ r₀) ↔ (x ≡ y)
d-refl x y = d-refl-r , d-refl-l

  where
   d-refl-r : (dist x y ≡ r₀) → (x ≡ y)
   d-refl-r h with case-abs (x - y)
   ... | inj₁ p = ⊥-elim (≡→≮ (-x=0→x=0 (x - y) h) (>-to-< p))
   ... | inj₂ p = x-y=0→x=y x y h

   d-refl-l : (x ≡ y) → (dist x y ≡ r₀)
   d-refl-l x=y =
     dist x y    ≡⟨ subst (λ w → dist x y ≡ abs (x - w)) (≡-sym x=y) (refl (dist x y)) ⟩
     abs (x - x) ≡⟨ subst (λ w → abs (x - x) ≡ abs w) (+-inve x) (refl (abs (x - x))) ⟩
     abs r₀      ≡⟨ abs-0 ⟩
     r₀      ∎

d-pos : (x y : ℝ) → dist x y ≥ r₀
d-pos x y with case-abs (x - y)
... | inj₁ p = inj₁ (x<0→-x>0 (>-to-< p))
... | inj₂ p = p

d-sym  : (x y : ℝ) → dist x y ≡ dist y x
d-sym x y with case-abs (x - y)
... | inj₁ p = ≡-sym (p₁-helper (>-+-cancel-r (p₂-helper (p₃-helper (<-to-> (x-y<0→x<y p))))) )

  where
   p₁-helper : y - x > r₀ → abs (y - x) ≡ - (x - y)
   p₁-helper h =
       abs (y - x) ≡⟨ x>0→absx=x (y - x) h ⟩
       y - x       ≡⟨ +-comm y (- x) ⟩
       - x + y     ≡⟨ subst (λ w → - x + y ≡ - x + w) (≡-sym mul--x) (refl (- x + y)) ⟩
       - x - (- y) ≡⟨ ≡-sym mul-x+y ⟩
       - (x - y)   ∎

   p₂-helper : y + r₀ > x → (y - x) + x > r₀ + x
   p₂-helper h = subst₂ (λ t₁ t₂ → t₁ > t₂) p₂₁-helper p₂₂-helper h

    where
     p₂₁-helper : y + r₀ ≡ y - x + x
     p₂₁-helper =
         y + r₀       ≡⟨ subst (λ w → y + r₀ ≡ y + w) (≡-sym (+-inve x)) (refl (y + r₀)) ⟩
         y + (x - x)  ≡⟨ subst (λ w → y + (x - x) ≡ y + w) (+-comm x (- x)) (refl (y + (x - x))) ⟩
         y + (- x + x)≡⟨ ≡-sym (+-asso y (- x) x) ⟩
         y - x + x    ∎

     p₂₂-helper : x ≡ r₀ + x
     p₂₂-helper =
          x      ≡⟨ ≡-sym (+-neut x) ⟩
          x + r₀ ≡⟨ +-comm x r₀ ⟩
          r₀ + x ∎

   p₃-helper : y > x → y + r₀ > x
   p₃-helper y>x = subst₂ (λ t₁ t₂ → t₁ > t₂) (≡-sym (+-neut y)) (refl x) y>x

... | inj₂ p = ≡-sym (case prf1 prf2 p)

    where
     prf1 : x - y > r₀ → abs (y - x) ≡ x - y
     prf1 h₁ =
       abs (y - x) ≡⟨ x<0→absx=-x (y - x) (-x>0→x<0 (p₁-helper h₁)) ⟩
       - (y - x)   ≡⟨ subst (λ w → - (y - x) ≡ - w) (+-comm y (- x)) (refl (- (y - x))) ⟩
       - (- x + y) ≡⟨ mul-x+y ⟩
       - (- x) - y ≡⟨ subst (λ w → - (- x) - y ≡ w - y) mul--x (refl (- (- x) - y)) ⟩
       x - y       ∎

      where
       p₁-helper : x - y > r₀ → - (y - x) > r₀
       p₁-helper h₂ = subst₂ (λ t₁ t₂ → t₁ > t₂) (≡-sym p₁₁-helper) (refl r₀) h₂

        where
         p₁₁-helper : - (y - x) ≡ x - y
         p₁₁-helper =
           - (y - x)   ≡⟨ subst (λ w → - (y - x) ≡ - w) (+-comm y (- x)) (refl (- (y - x))) ⟩
           - (- x + y) ≡⟨ mul-x+y ⟩
           - (- x) - y ≡⟨ subst (λ w → - (- x) - y ≡ w - y) mul--x (refl (- (- x) - y)) ⟩
           x - y       ∎

     prf2 : x - y ≡ r₀ → abs (y - x) ≡ x - y
     prf2 h₃ =
           abs (y - x) ≡⟨ subst (λ w → abs (y - x) ≡ abs (y - w)) (x-y=0→x=y x y h₃) (refl (abs (y - x))) ⟩
           abs (y - y) ≡⟨ subst (λ w → abs (y - y) ≡ abs w) (+-inve y) (refl (abs (y - y))) ⟩
           abs r₀      ≡⟨ abs-0 ⟩
           r₀          ≡⟨ ≡-sym (+-inve y) ⟩
           y - y       ≡⟨ subst (λ w → y - y ≡ w - y) (≡-sym (x-y=0→x=y x y h₃)) (refl (y - y)) ⟩
           x - y        ∎
