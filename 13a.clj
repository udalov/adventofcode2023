; clj -M 13a.clj

(require 'clojure.string)

(defn transpose [lines]
  (apply vector (apply map str lines)))

(defn check? [lines i]
  (def indices (range i (min (count lines) (* i 2))))
  (def pairs (map (fn [x] (list x (- (* i 2) (inc x)))) indices))
  (every? (fn [ij] (= (get lines (first ij)) (get lines (second ij)))) pairs))

(defn find-row [lines]
  (def indices (range 1 (count lines)))
  (first (filter (partial check? lines) indices)))

(defn solve-impl [lines]
  (or (find-row (transpose lines))
    (* 100 (find-row lines))))

(defn solve [lines result]
  (def line (read-line))
  (if (clojure.string/blank? line)
    (let [cur (+ result (solve-impl lines))]
      (if (nil? line) cur (solve [] cur)))
    (solve (conj lines line) result)))

(defn main []
  (println (solve [] 0)))

(main)
