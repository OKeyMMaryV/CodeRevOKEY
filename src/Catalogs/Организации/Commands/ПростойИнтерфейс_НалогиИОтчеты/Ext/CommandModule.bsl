﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = ОбщегоНазначенияБПКлиентСервер.ПараметрыОткрытияФормыСОжиданием(ПараметрыВыполненияКоманды);
	ПараметрыОткрытия.Заголовок = НСтр("ru = 'Настройки налогов и отчетов'");
	ПараметрыОткрытия.ИмяФормы = "ОбщаяФорма.НалогиИОтчеты";
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", ОсновнаяОрганизация());
	
	ОбщегоНазначенияБПКлиент.ОткрытьФормуСОжиданием(ПараметрыОткрытия, ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОсновнаяОрганизация()
	
	Возврат БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	
КонецФункции

#КонецОбласти