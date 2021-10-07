﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ТЧ_ИсторияСтатусов") Тогда
		ок_ИсторияСтатусов.Загрузить(Параметры.ТЧ_ИсторияСтатусов.Выгрузить());
	КонецЕсли;
	
	Если Параметры.Свойство("Контрагент") Тогда
		Контрагент = Параметры.Контрагент;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура();
	ПараметрыОтбора.Вставить("Период");
	ПараметрыОтбора.Вставить("Статус");
	ПараметрыОтбора.Вставить("Ответственный");
	Для каждого ТекущаяСтрока Из ок_ИсторияСтатусов Цикл
	
		ЗаполнитьЗначенияСвойств(ПараметрыОтбора, ТекущаяСтрока);
		НайденныеСтроки = Контрагент.ок_ИсторияСтатусов.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() > 0 Тогда
			ТекущаяСтрока.ЗаписанаВБД = Истина;
		КонецЕсли;

	КонецЦикла; 
	
	Если ок_ИсторияСтатусов.Количество() = 0 Тогда
		
		НоваяСтрока = ок_ИсторияСтатусов.Добавить();
		НоваяСтрока.Период 		  = ТекущаяДата();
		НоваяСтрока.Ответственный = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь");;
		
	КонецЕсли;
	
	Если ЭтаФорма.ок_ИсторияСтатусов.Количество() > 0 Тогда
		Элементы.ок_ИсторияСтатусов.ТекущаяСтрока = (ЭтаФорма.ок_ИсторияСтатусов.Количество() - 1);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ок_ИсторияСтатусовПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.ок_ИсторияСтатусов.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено
		И ТекущиеДанные.ЗаписанаВБД Тогда
	
		Отказ = Истина;
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ок_ИсторияСтатусовПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.ок_ИсторияСтатусов.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено
		И НоваяСтрока Тогда
	
		ТекущиеДанные.Период = ТекущаяДата();
		ТекущиеДанные.Ответственный = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь");;
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка_Ок(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
	
		Возврат;
	
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура();
	СтруктураОтбора.Вставить("ЗаписанаВБД", Ложь);
	НайденныеСтроки = ок_ИсторияСтатусов.НайтиСтроки(СтруктураОтбора);
	
	ПараметрЗакрытия = Новый Структура();
	ПараметрЗакрытия.Вставить("ТЧ_ИсторияСтатусов", ок_ИсторияСтатусов);
	ПараметрЗакрытия.Вставить("ПоследнийСтатус", 	?(ок_ИсторияСтатусов.Количество() > 0, ок_ИсторияСтатусов[ок_ИсторияСтатусов.Количество() - 1].Статус, Неопределено));
	ПараметрЗакрытия.Вставить("Модифицированность", НайденныеСтроки.Количество() > 0);
	
	Закрыть(ПараметрЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка_Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Для Инд = 0 По ок_ИсторияСтатусов.Количество() - 1 Цикл
		
		ТекущаяСтрока = ок_ИсторияСтатусов[Инд];
		
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.Статус) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Строка(" + (Инд + 1) + ") Необходимо заполнить статус!",,"ок_ИсторияСтатусов[" + Инд + "].Статус",, Отказ);
		КонецЕсли; 
	
	КонецЦикла; 
	
КонецПроцедуры
