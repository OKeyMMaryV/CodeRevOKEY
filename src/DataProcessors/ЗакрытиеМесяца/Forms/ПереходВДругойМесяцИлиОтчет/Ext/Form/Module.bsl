﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.ДатаМесяца)
		ИЛИ Не ЗначениеЗаполнено(Параметры.ПериодРегистрации) Тогда
			Отказ = Истина;
			ВызватьИсключение СтрШаблон(НСтр("ru = '%1, недостаточно параметров для открытия формы'"), ИмяФормы);
		Возврат;
	КонецЕсли;

	КлючСохраненияПоложенияОкна = Параметры.НазначениеФормы;
	
	КомандаПерейти = Параметры.НазначениеФормы;
	
	Если КомандаПерейти = "ПерейтиВСледующийМесяц" Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Теперь можно перейти к закрытию %1 г.'"),
			ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(Параметры.ДатаМесяца, 2));
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 г. закрыт'"),
			ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(Параметры.ПериодРегистрации, 1));
		ТекстКнопкиПерейти = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Перейти к закрытию %1 г.'"),
			ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(Параметры.ДатаМесяца, 2));
			
	ИначеЕсли КомандаПерейти = "СформироватьОтчет" Тогда
		
		ТекстСообщения = НСтр("ru = 'Теперь можно сформировать отчет'");
		
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 г. закрыт'"),
			ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(Параметры.ПериодРегистрации, 1));
		
		ТекстКнопкиПерейти = НСтр("ru = 'Сформировать отчет'");
		
	Иначе
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сначала нужно закрыть %1 г.'"),
			ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(Параметры.ДатаМесяца, 4));
		
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 г. закрывать еще рано'"),
			ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(Параметры.ПериодРегистрации, 4));
			
		ТекстКнопкиПерейти = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Перейти к закрытию %1 г.'"),
			ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(Параметры.ДатаМесяца, 2));
			
		Элементы.МесяцЗакрыт.Видимость = Ложь;
		
	КонецЕсли;
	
	Элементы.ПерейтиКЗакрытию.Заголовок = ТекстКнопкиПерейти;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчкиКоманд

&НаКлиенте
Процедура ПерейтиКзакрытию(Команда)
	
	Если КомандаПерейти = "СформироватьОтчет" Тогда
		Закрыть("СформироватьОтчет");
	Иначе
		Закрыть("Перейти");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеСейчас(Команда)
	Закрыть("Отмена");
КонецПроцедуры

#КонецОбласти
