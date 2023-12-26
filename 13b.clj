; clj -M 13b.clj

(require 'clojure.string)

(defn transpose [lines]
  (apply vector (apply map str lines)))

(defn check? [lines i]
  (def indices (range i (min (count lines) (* i 2))))
  (def pairs (map (fn [x] (list x (- (* i 2) (inc x)))) indices))
  (every? (fn [ij] (= (get lines (first ij)) (get lines (second ij)))) pairs))

(defn find-row [lines avoid]
  (def indices (range 1 (count lines)))
  (first (filter (fn [i] (and (not= i avoid) (check? lines i))) indices)))

(defn solve-one [lines avoid]
  (def avoid-row (if (and avoid (>= avoid 100)) (/ avoid 100) nil))
  (def row (let [v (find-row lines avoid-row)] (and v (* 100 v))))
  (def col (find-row (transpose lines) avoid))
  (or row col))

(defn opposite [c]
  (if (= c \#) \. \#))

(defn besmudge [s i]
  (str (subs s 0 i) (opposite (get s i)) (subs s (inc i))))

(defn smudge [lines avoid xy]
  (def x (first xy))
  (def y (second xy))
  (solve-one (assoc lines x (besmudge (get lines x) y)) avoid))

(defn solve-impl [lines]
  (def avoid (solve-one lines nil))
  (def indices (for [x (range (count lines)) y (range (count (first lines)))] [x y]))
  (first (filter some? (map (partial smudge lines avoid) indices))))

(defn solve [lines result]
  (def line (read-line))
  (if (clojure.string/blank? line)
    (let [cur (+ result (solve-impl lines))]
      (if (nil? line) cur (solve [] cur)))
    (solve (conj lines line) result)))

(defn main []
  (println (solve [] 0)))

(main)
