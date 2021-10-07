﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = ОбщегоНазначенияБПКлиентСервер.ПараметрыОткрытияФормыСОжиданием(ПараметрыВыполненияКоманды);
	ПараметрыОткрытия.Заголовок = НСтр("ru = 'Регистрации в налоговых органах'");
	ПараметрыОткрытия.ИмяФормы = "Справочник.РегистрацииВНалоговомОргане.ФормаСписка";

	Отбор = Новый Структура("Владелец", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	
	ОбщегоНазначенияБПКлиент.ОткрытьФормуСОжиданием(ПараметрыОткрытия, ПараметрыФормы);

КонецПроцедуры
