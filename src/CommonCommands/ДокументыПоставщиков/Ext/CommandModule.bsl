﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = ОбщегоНазначенияБПКлиентСервер.ПараметрыОткрытияФормыСОжиданием(ПараметрыВыполненияКоманды);
	ПараметрыОткрытия.ИмяФормы = "ЖурналДокументов.ЖурналОпераций.ФормаСписка";
	ПараметрыОткрытия.ЗамерПроизводительности = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru='Документы поставщиков'"));
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "ДокументыПоставщиков");
	
	ОбщегоНазначенияБПКлиент.ОткрытьФормуСОжиданием(ПараметрыОткрытия, ПараметрыФормы);
	
КонецПроцедуры
