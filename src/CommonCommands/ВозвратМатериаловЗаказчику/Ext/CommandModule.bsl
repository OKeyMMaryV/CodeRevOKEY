﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отбор = Новый Структура("ВидОперации",
		ПредопределенноеЗначение("Перечисление.ВидыОперацийВозвратТоваровПоставщику.ИзПереработки"));
	
	ПараметрыОткрытия = ОбщегоНазначенияБПКлиентСервер.ПараметрыОткрытияФормыСОжиданием(ПараметрыВыполненияКоманды);
	ПараметрыОткрытия.Заголовок    = ПолноеИмяОперации(Отбор.ВидОперации);
	ПараметрыОткрытия.ИмяФормы     = "Документ.ВозвратТоваровПоставщику.ФормаСписка";
	ПараметрыОткрытия.Уникальность = Отбор.ВидОперации;

	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	
	ОбщегоНазначенияБПКлиент.ОткрытьФормуСОжиданием(ПараметрыОткрытия, ПараметрыФормы);

КонецПроцедуры

&НаСервере
Функция ПолноеИмяОперации(ВидОперации)
	
	Возврат Перечисления.ВидыОперацийВозвратТоваровПоставщику.ПолноеИмяОперации(ВидОперации);
	
КонецФункции
