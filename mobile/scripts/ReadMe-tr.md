# Scripts

Bu klasörde, projenizde kullanılan bash scriptleri bulunmaktadır. Bu scriptler, projenizdeki bazı işlemleri otomatikleştirmek için kullanılır.


## 1. Localization

Bu bash script, easy_localization adlı bir paketin bir komut dosyası olan generate komutunu çalıştırır. Bu komut dosyası, projedeki assets/i10n/ klasöründeki tüm <lang_code>.json dosyalarını okuyarak, her bir dil için lib/core/localization/ klasöründe bulunan tüm değişkenleri tanımlayan bir sınıf oluşturur. Bu sınıflar, locale_keys.g.dart adlı bir dosyaya yazılır ve projenin yerel dil desteği için kullanılır.

Özetle, bu script, projenin yerelleştirme işlemini kolaylaştırmak için kullanılan easy_localization paketinin bir özelliği olan kod oluşturma sürecini otomatikleştirir. Bu sayede, projenin yerel dil desteği için gerekli olan keylerin oluşturulması daha hızlı ve hatasız bir şekilde gerçekleştirilebilir.

```{r, engine='bash', count_lines}
sh scripts/localization.sh
```

## 2. Build Runner

Bu bash script, build_runner adlı bir paketin komutunu çalıştırır. Bu komut, projenizdeki tüm generatorları çalıştırır. Bu sayede, projenizdeki tüm kod oluşturma işlemleri gerçekleştirilir.

```{r, engine='bash', count_lines}
sh scripts/build_runner.sh
```

## 3. Build

Bu script, projenizin debug ve release modlarında build işlemini gerçekleştirir. Flavors entegre edilmiş haliyle projenizde kullanılmaktadır. Flavors kullanmıyorsanız, <flavor_name> eklemeden çalıştırabilirsiniz.

```{r, engine='bash', count_lines}
sh scripts/build.sh -apk <flavor_name>
```
```{r, engine='bash', count_lines}
sh scripts/build.sh -bundle <flavor_name>
```

> Not: İsterseniz, bu scriptleri, projenizin root dizininde bulunan .vscode/launch.json dosyasında bulunan "preLaunchTask" alanına ekleyebilirsiniz. Bu sayede, projenizdeki build işlemleri, debug veya release modlarında çalıştırıldığında otomatik olarak gerçekleştirilecektir.

> Bu alana kullandığınız güzel scriptleri eklemel isterseniz seve seve değerlendiriyor olurum.
