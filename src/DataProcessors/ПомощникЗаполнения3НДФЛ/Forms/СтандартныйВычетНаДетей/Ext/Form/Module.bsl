﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидДохода = Перечисления.ИсточникиДоходовФизическихЛиц.ПредпринимательскаяДеятельность;
	СемейноеПоложениеНеИзменялось = Истина;
	ВыбраннаяФорма = Параметры.Декларация3НДФЛВыбраннаяФорма;
	ПрименятьВычет = Не Параметры.КонтекстныйВызов;
	КонтекстныйВызов = Параметры.КонтекстныйВызов;
	
	Если Параметры.Свойство("СтруктураДоходовВычетов") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.СтруктураДоходовВычетов, , "СведенияОДетях");
		Если Параметры.СтруктураДоходовВычетов.Свойство("СведенияОДетях") Тогда
			СведенияОДетях.Очистить();
			ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(Параметры.СтруктураДоходовВычетов.СведенияОДетях, СведенияОДетях);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, СведенияОДетях[0]);
		КонецЕсли;
		
	Иначе
		
		КоличествоМесяцев = КоличествоМесяцевКВычету(
			Параметры.Организация, Параметры.Период, ВыбраннаяФорма, УникальныйИдентификатор);
		ЗаполнитьТаблицуСтандартныйВычет();
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
	КлючСохраненияПоложенияОкна = СтрШаблон("%1%2", СемейноеПоложениеНеИзменялось, КонтекстныйВызов);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ПрименятьВычет Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВсегоДетей");
		МассивНепроверяемыхРеквизитов.Добавить("Несовершеннолетних");
		МассивНепроверяемыхРеквизитов.Добавить("КоличествоМесяцев");
	ИначеЕсли КонтекстныйВызов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КоличествоМесяцев");
	КонецЕсли;
	
	Если СемейноеПоложениеНеИзменялось Тогда
		ТекстОшибкиВсегоДетей   = НСтр("ru = 'Число несовершеннолетних детей превышает общее количество детей'");
		ТекстОшибкиДетиИнвалиды = НСтр("ru = 'Детей-инвалидов больше, чем несовершеннолетних детей'");
		Если Несовершеннолетних > ВсегоДетей Тогда
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибкиВсегоДетей, , "ВсегоДетей", , Отказ);
		КонецЕсли;
		
		Если РодныеДетиИнвалиды + ПриемныеДетиИнвалиды > Несовершеннолетних Тогда
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибкиДетиИнвалиды, , "Несовершеннолетних", , Отказ);
		КонецЕсли;
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ВсегоДетей");
		МассивНепроверяемыхРеквизитов.Добавить("Несовершеннолетних");
		
		// Хотя бы в одном из месяцев должно быть указано общее количество детей.
		Если СведенияОДетях.Итог("ВсегоДетей") = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Укажите общее количество детей хотя бы в одной строке'");
			ПутьКСтроке = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("СведенияОДетях", 1, "ВсегоДетей");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , ПутьКСтроке, , Отказ);
			ПроверяемыеРеквизиты.Добавить("СведенияОДетях.ВсегоДетей");
		КонецЕсли;
		
		// Хотя бы в одном из месяцев должно быть указано количество несовершеннолетних детей.
		Если СведенияОДетях.Итог("Несовершеннолетних") = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Укажите количество несовершеннолетних детей хотя бы в одной строке'");
			ПутьКСтроке = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("СведенияОДетях", 1, "Несовершеннолетних");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , ПутьКСтроке, , Отказ);
			ПроверяемыеРеквизиты.Добавить("СведенияОДетях.Несовершеннолетних");
		КонецЕсли;
		
		// Если количество детей указано хотя бы в одной строке, то проверяем корректность заполнения построчно.
		Если НЕ Отказ Тогда
			ТекстОшибкиВсегоДетей   = НСтр("ru = 'В %1 число несовершеннолетних детей превышает общее количество детей'");
			ТекстОшибкиДетиИнвалиды = НСтр("ru = 'В %1 детей-инвалидов больше, чем несовершеннолетних детей'");
			Для Индекс = 0 По СведенияОДетях.Количество() - 1 Цикл
				СтрокаТаблицы = СведенияОДетях[Индекс];
				НомерСтроки = Индекс + 1;
				Если СтрокаТаблицы.Несовершеннолетних > СтрокаТаблицы.ВсегоДетей Тогда
					ПутьКСтроке = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("СведенияОДетях", НомерСтроки, "ВсегоДетей");
					ТекстСообщения = СтрШаблон(ТекстОшибкиВсегоДетей, МесяцВПредложномПадеже(НомерСтроки));
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , ПутьКСтроке, , Отказ);
				КонецЕсли;
				
				Если СтрокаТаблицы.РодныеДетиИнвалиды + СтрокаТаблицы.ПриемныеДетиИнвалиды > СтрокаТаблицы.Несовершеннолетних Тогда
					ПутьКСтроке = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("СведенияОДетях", НомерСтроки, "Несовершеннолетних");
					ТекстСообщения = СтрШаблон(ТекстОшибкиДетиИнвалиды, МесяцВПредложномПадеже(НомерСтроки));
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , ПутьКСтроке, , Отказ);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПрименятьВычетПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДоходаПриИзменении(Элемент)
	УстановитьПодсказкуКоличествоМесяцев(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СемейноеПоложениеПриИзменении(Элемент)
	
	Если СемейноеПоложениеНеИзменялось Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СведенияОДетях[0]);
		Для Каждого ТекущаяСтрока Из СведенияОДетях Цикл
			ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ЭтотОбъект);
		КонецЦикла;
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВсегоДетейПриИзменении(Элемент)
	СведенияОДетях[0].ВсегоДетей = ВсегоДетей;
	ЗаполнитьЗначенияТаблицыСведенияОДетях(СведенияОДетях[0], "ВсегоДетей");
КонецПроцедуры

&НаКлиенте
Процедура НесовершеннолетнихПриИзменении(Элемент)
	СведенияОДетях[0].Несовершеннолетних = Несовершеннолетних;
	ЗаполнитьЗначенияТаблицыСведенияОДетях(СведенияОДетях[0], "Несовершеннолетних");
КонецПроцедуры

&НаКлиенте
Процедура РодныеДетиИнвалидыПриИзменении(Элемент)
	СведенияОДетях[0].РодныеДетиИнвалиды = РодныеДетиИнвалиды;
	ЗаполнитьЗначенияТаблицыСведенияОДетях(СведенияОДетях[0], "РодныеДетиИнвалиды");
	УстановитьЗаголовокГруппы(ЭтотОбъект, "ГруппаДетиИнвалиды", ТекстЗаголовкаГруппыДетиИнвалиды(ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ПриемныеДетиИнвалидыПриИзменении(Элемент)
	СведенияОДетях[0].ПриемныеДетиИнвалиды = ПриемныеДетиИнвалиды;
	ЗаполнитьЗначенияТаблицыСведенияОДетях(СведенияОДетях[0], "ПриемныеДетиИнвалиды");
	УстановитьЗаголовокГруппы(ЭтотОбъект, "ГруппаДетиИнвалиды", ТекстЗаголовкаГруппыДетиИнвалиды(ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ПрименяетсяДвойнойВычетПриИзменении(Элемент)
	СведенияОДетях[0].ПрименяетсяДвойнойВычет = ПрименяетсяДвойнойВычет;
	ЗаполнитьЗначенияТаблицыСведенияОДетях(СведенияОДетях[0], "ПрименяетсяДвойнойВычет");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСтандартныйВычет

&НаКлиенте
Процедура СведенияОДетяхВсегоДетейПриИзменении(Элемент)
	ЗаполнитьЗначенияТаблицыСведенияОДетях(Элементы.СведенияОДетях.ТекущиеДанные, "ВсегоДетей");
КонецПроцедуры

&НаКлиенте
Процедура СведенияОДетяхНесовершеннолетнихПриИзменении(Элемент)
	ЗаполнитьЗначенияТаблицыСведенияОДетях(Элементы.СведенияОДетях.ТекущиеДанные, "Несовершеннолетних");
КонецПроцедуры

&НаКлиенте
Процедура СведенияОДетяхРодныеДетиИнвалидыПриИзменении(Элемент)
	ЗаполнитьЗначенияТаблицыСведенияОДетях(Элементы.СведенияОДетях.ТекущиеДанные, "РодныеДетиИнвалиды");
КонецПроцедуры

&НаКлиенте
Процедура СведенияОДетяхПриемныеДетиИнвалидыПриИзменении(Элемент)
	ЗаполнитьЗначенияТаблицыСведенияОДетях(Элементы.СведенияОДетях.ТекущиеДанные, "ПриемныеДетиИнвалиды");
КонецПроцедуры

&НаКлиенте
Процедура СведенияОДетяхПрименяетсяДвойнойВычетПриИзменении(Элемент)
	ЗаполнитьЗначенияТаблицыСведенияОДетях(Элементы.СведенияОДетях.ТекущиеДанные, "ПрименяетсяДвойнойВычет");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураОтвета = НовыйСтруктураОтветаФормы();
	
	Если ПрименятьВычет Тогда
		
		ДополнитьСтруктуруРезультатаФормы(СтруктураОтвета);
		
	КонецЕсли;
	
	Закрыть(СтруктураОтвета);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция НовыйСтруктураОтветаФормы()
	
	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("КоличествоМесяцев", КоличествоМесяцев);
	СтруктураОтвета.Вставить("Вид",               ПредопределенноеЗначение("Перечисление.ВычетыФизическихЛиц.СтандартныйНаДетей"));
	СтруктураОтвета.Вставить("Информация",        СтрШаблон(НСтр("ru = 'Вычет на детей (%1)'"), Несовершеннолетних));
	СтруктураОтвета.Вставить("ВидДохода",         ВидДохода);
	СтруктураОтвета.Вставить("СемейноеПоложениеНеИзменялось", СемейноеПоложениеНеИзменялось);
	СтруктураОтвета.Вставить("СуммаВычета",       0);
	СтруктураОтвета.Вставить("СведенияОВычетах", Неопределено);
	СтруктураОтвета.Вставить("СтандартныйВычет",  0);
	СтруктураОтвета.Вставить("ДвойнойВычет",      0);
	СтруктураОтвета.Вставить("ВычетНаИнвалидов",  0);
	СтруктураОтвета.Вставить("ДвойнойВычетНаИнвалидов", 0);
	
	Возврат СтруктураОтвета;
	
КонецФункции

&НаСервере
Процедура ДополнитьСтруктуруРезультатаФормы(ДанныеРезультат)
	
	СуммыВычета  = РассчитатьСуммыВычета(СведенияОДетях, ВыбраннаяФорма, КоличествоМесяцев);
	ДанныеВычета = СведенияОДетях.Выгрузить();
	
	Если ДанныеРезультат.КоличествоМесяцев = 0 Тогда
		
		ДанныеРезультат.Вставить("СуммаВычета", 0);
		
	Иначе
		
		ДанныеРезультат.Вставить("СведенияОДетях",   ОбщегоНазначения.ТаблицаЗначенийВМассив(ДанныеВычета));
		ДанныеРезультат.Вставить("СведенияОВычетах", ИтоговыеЗначенияВычетов(ДанныеВычета));
		ДанныеРезультат.Вставить("СуммаВычета",      СуммыВычета.Всего);
		ДанныеРезультат.Вставить("СтандартныйВычет", СуммыВычета.СтандартныйВычет);
		ДанныеРезультат.Вставить("ДвойнойВычет",     СуммыВычета.ДвойнойВычет);
		ДанныеРезультат.Вставить("ВычетНаИнвалидов", СуммыВычета.ВычетНаИнвалидов);
		ДанныеРезультат.Вставить("ДвойнойВычетНаИнвалидов", СуммыВычета.ДвойнойВычетНаИнвалидов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИтоговыеЗначенияВычетов(ДанныеВычета)
	
	ИндексСтроки = 0;
	КоличествоСтрок = ДанныеВычета.Количество();
	
	// Данные вычета необходимо свернуть по периоду
	РезультатСвертки = ДанныеВычета.СкопироватьКолонки();
	
	Пока ИндексСтроки < КоличествоСтрок Цикл
		
		ТекущаяСтрока = ДанныеВычета[ИндексСтроки];
		
		СуммаВычета = 0;
		Для СледующийИндексСтроки = ИндексСтроки + 1 По КоличествоСтрок - 1 Цикл
			
			Если ТекущаяСтрока.ВсегоДетей <> ДанныеВычета[СледующийИндексСтроки].ВсегоДетей
				Или ТекущаяСтрока.Несовершеннолетних <> ДанныеВычета[СледующийИндексСтроки].Несовершеннолетних
				Или ТекущаяСтрока.ПрименяетсяДвойнойВычет <> ДанныеВычета[СледующийИндексСтроки].ПрименяетсяДвойнойВычет
				Или ТекущаяСтрока.РодныеДетиИнвалиды <> ДанныеВычета[СледующийИндексСтроки].РодныеДетиИнвалиды
				Или ТекущаяСтрока.ПриемныеДетиИнвалиды <> ДанныеВычета[СледующийИндексСтроки].ПриемныеДетиИнвалиды Тогда
				
				Прервать;
				
			КонецЕсли;
			
			СуммаВычета = СуммаВычета + ДанныеВычета[СледующийИндексСтроки].СуммаВычета;
			
		КонецЦикла;
		
		НоваяСтрока = РезультатСвертки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
		НоваяСтрока.СуммаВычета = НоваяСтрока.СуммаВычета + СуммаВычета;
		
		ИндексСтроки = СледующийИндексСтроки;
		
	КонецЦикла;
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(РезультатСвертки);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	// Если форма вызывается не из помощника заполнения 3-НДФЛ,
	// тогда необходимо изменить видимость элементов, предназначенных только для помощника
	Элементы.ГруппаПрименениеВычета.Видимость = Форма.КонтекстныйВызов;
	Элементы.ГруппаВидДоходаКоличествоМесяцев.Видимость = Не Форма.КонтекстныйВызов;
	Элементы.СемейноеПоложение.Видимость = Не Форма.КонтекстныйВызов;
	
	Элементы.ГруппаНетИзменений.Видимость = Форма.СемейноеПоложениеНеИзменялось;
	Элементы.ГруппаЕстьИзменения.Видимость = Не Форма.СемейноеПоложениеНеИзменялось;
	
	УстановитьЗаголовокГруппы(Форма, "ГруппаДетиИнвалиды", ТекстЗаголовкаГруппыДетиИнвалиды(Форма));
	
	Элементы.ГруппаВидДоходаКоличествоМесяцев.Доступность = Форма.ПрименятьВычет;
	Элементы.СемейноеПоложение.Доступность = Форма.ПрименятьВычет;
	Элементы.ГруппаНетИзменений.Доступность = Форма.ПрименятьВычет;
	Элементы.ГруппаЕстьИзменения.Доступность = Форма.ПрименятьВычет;
	Элементы.ВычетПрименяетсяПериод.Доступность = Форма.ПрименятьВычет;
	
	УстановитьПодсказкуКоличествоМесяцев(Форма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуСтандартныйВычет()
	
	ПараметрыВыполнения = УчетНДФЛПредпринимателя.НовыйПараметрыВычета();
	ЗаполнитьЗначенияСвойств(ПараметрыВыполнения, Параметры);
	ПараметрыВыполнения.ИмяОбъектаМетаданных = "РегистрСведений.ИПСтандартныеВычетыНаДетей";
	ПараметрыВыполнения.КоличествоМесяцев = КоличествоМесяцев;
	ПараметрыВыполнения.ВыбраннаяФорма = ВыбраннаяФорма;
	ПараметрыВыполнения.ВычетЗаВесьПериод = Не Параметры.КонтекстныйВызов;
	
	Если Не ЗначениеЗаполнено(ПараметрыВыполнения.НачалоПериода) Тогда
		ПараметрыВыполнения.НачалоПериода = НачалоГода(Параметры.Период);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыВыполнения.КонецПериода) Тогда
		ПараметрыВыполнения.КонецПериода = КонецГода(Параметры.Период);
	КонецЕсли;
	
	ДанныеВычета = УчетНДФЛПредпринимателя.ДанныеВычетаПоМесяцамЗаПериод(ПараметрыВыполнения);
	
	// Значение по умолчанию всегда Истина, если через контекстный вызов не передано иное значение
	// или ранее было установлено, что вычет не применяется
	Если Параметры.КонтекстныйВызов И ДанныеВычета.Итог("СуммаВычета") = 0 Тогда
		ПрименятьВычет = Ложь;
	ИначеЕсли Параметры.КонтекстныйВызов Тогда
		ПрименятьВычет = Параметры.ПрименятьВычет;
	Иначе
		ПрименятьВычет = Истина;
	КонецЕсли;
	
	// Начальное заполнение таблицы сведений
	Если Не ЗначениеЗаполнено(ДанныеВычета) Тогда
		
		МесяцНачало = Мин(1, Месяц(ПараметрыВыполнения.НачалоПериода));
		МесяцКонец  = Месяц(ПараметрыВыполнения.КонецПериода);
		ЗаполнитьТаблицуПоУмолчанию(0, ДанныеВычета, МесяцНачало, МесяцКонец);
		ПрименятьВычет = Истина;
		
	КонецЕсли;
	
	СведенияОДетях.Загрузить(ДанныеВычета);
	
	СемейноеПоложениеНеИзменялось = Истина;
	Для Каждого ТекущийВычет Из ДанныеВычета Цикл
		
		Если ДанныеВычета[0].ВсегоДетей <> ТекущийВычет.ВсегоДетей
			Или ДанныеВычета[0].ВсегоДетей <> ТекущийВычет.ВсегоДетей
			Или ДанныеВычета[0].Несовершеннолетних <> ТекущийВычет.Несовершеннолетних
			Или ДанныеВычета[0].ПриемныеДетиИнвалиды <> ТекущийВычет.ПриемныеДетиИнвалиды
			Или ДанныеВычета[0].РодныеДетиИнвалиды <> ТекущийВычет.РодныеДетиИнвалиды
			Или ДанныеВычета[0].ПрименяетсяДвойнойВычет <> ТекущийВычет.ПрименяетсяДвойнойВычет Тогда
			
			СемейноеПоложениеНеИзменялось = Ложь;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеВычета[0]);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПоУмолчанию(КоличествоДетей, ДанныеВычета = Неопределено, МесяцНачало = 1, МесяцКонец = 12)
	
	Если ДанныеВычета = Неопределено Тогда
		ДанныеВычета = СведенияОДетях;
	КонецЕсли;
	
	Для НомерМесяца = МесяцНачало По МесяцКонец Цикл
		
		СтрокаВычет = ДанныеВычета.Добавить();
		СтрокаВычет.НомерМесяца = НомерМесяца;
		СтрокаВычет.Месяц = ОбщегоНазначенияБПКлиентСервер.ПредставлениеМесяца(НомерМесяца);
		СтрокаВычет.ВсегоДетей = КоличествоДетей;
		СтрокаВычет.Несовершеннолетних = КоличествоДетей;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗначенияТаблицыСведенияОДетях(СтрокаЭталон, ИмяКолонки)
	
	Для Каждого СтрокаТаблицы Из СведенияОДетях Цикл
		Если СтрокаТаблицы.НомерМесяца > СтрокаЭталон.НомерМесяца Тогда
			СтрокаТаблицы[ИмяКолонки] = СтрокаЭталон[ИмяКолонки];
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокГруппы(Форма, НазваниеГруппы, ЗаголовокТекст)
	
	Форма.Элементы[НазваниеГруппы].ЗаголовокСвернутогоОтображения = ЗаголовокТекст;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекстЗаголовкаГруппыДетиИнвалиды(Форма)
	
	СтрокаСведений = Форма.СведенияОДетях[0];
	ТекстЗаголовка = СтрШаблон(НСтр("ru = 'Из них детей-инвалидов: %1'"),
		Формат(СтрокаСведений.РодныеДетиИнвалиды + СтрокаСведений.ПриемныеДетиИнвалиды, "ЧН=; ЧГ=0"));
	
	Возврат ТекстЗаголовка;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция УстановитьПодсказкуКоличествоМесяцев(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"КоличествоМесяцевРасширеннаяПодсказка",
		"Заголовок",
		ТекстПодсказкиКоличествоМесяцев(Форма.ВидДохода));
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекстПодсказкиКоличествоМесяцев(ВидДохода)
	
	Если ВидДохода = ПредопределенноеЗначение("Перечисление.ИсточникиДоходовФизическихЛиц.ОплатаТруда") Тогда
		ТекстПодсказки = НСтр("ru = 'Рассчитайте количество месяцев применения
		|вычета по справке 2-НДФЛ.
		|Применение вычета прекращается с месяца,
		|в котором общая сумма дохода с начала года
		|превысила 350 тыс. руб.'");
	ИначеЕсли ВидДохода = ПредопределенноеЗначение("Перечисление.ИсточникиДоходовФизическихЛиц.ПредпринимательскаяДеятельность") Тогда
		ТекстПодсказки = НСтр("ru = 'Рассчитывается автоматически по доходам
		|от предпринимательской деятельности.
		|Применение вычета прекращается с месяца,
		|в котором общая сумма дохода с начала года
		|превысила 350 тыс. руб.'");
	Иначе
		ТекстПодсказки = НСтр("ru = 'Рассчитайте самостоятельно количество месяцев
		|применения вычета по полученным доходам.
		|Применение вычета прекращается с месяца,
		|в котором общая сумма дохода с начала года
		|превысила 350 тыс. руб.'");
	КонецЕсли;
	
	Возврат ТекстПодсказки;
	
КонецФункции

&НаСервереБезКонтекста
Функция МесяцВПредложномПадеже(НомерМесяца)
	
	Если НомерМесяца = 1 Тогда
		Возврат НСтр("ru = 'январе'");
	ИначеЕсли НомерМесяца = 2 Тогда
		Возврат НСтр("ru = 'феврале'");
	ИначеЕсли НомерМесяца = 3 Тогда
		Возврат НСтр("ru = 'марте'");
	ИначеЕсли НомерМесяца = 4 Тогда
		Возврат НСтр("ru = 'апреле'");
	ИначеЕсли НомерМесяца = 5 Тогда
		Возврат НСтр("ru = 'мае'");
	ИначеЕсли НомерМесяца = 6 Тогда
		Возврат НСтр("ru = 'июне'");
	ИначеЕсли НомерМесяца = 7 Тогда
		Возврат НСтр("ru = 'июле'");
	ИначеЕсли НомерМесяца = 8 Тогда
		Возврат НСтр("ru = 'августе'");
	ИначеЕсли НомерМесяца = 9 Тогда
		Возврат НСтр("ru = 'сентябре'");
	ИначеЕсли НомерМесяца = 10 Тогда
		Возврат НСтр("ru = 'октябре'");
	ИначеЕсли НомерМесяца = 11 Тогда
		Возврат НСтр("ru = 'ноябре'");
	ИначеЕсли НомерМесяца = 12 Тогда
		Возврат НСтр("ru = 'декабре'");
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаСервереБезКонтекста
Функция РассчитатьСуммыВычета(СведенияОДетях, ВыбраннаяФорма, КоличествоМесяцев)
	
	РазмерыВычетов = Отчеты.РегламентированныйОтчет3НДФЛ.РазмерыВычетов(ВыбраннаяФорма);
	Возврат РегистрыСведений.ИПСтандартныеВычетыНаДетей.РассчитатьСуммыВычетаНаДетей(
		СведенияОДетях.Выгрузить(), РазмерыВычетов.СтандартныйВычетНаДетей, КоличествоМесяцев);
	
КонецФункции

&НаСервереБезКонтекста
Функция КоличествоМесяцевКВычету(Организация, Период, Декларация3НДФЛВыбраннаяФорма, УникальныйИдентификатор)
	
	ПараметрыВыполнения = УчетНДФЛПредпринимателя.НовыеПараметрыРасчетаДоходыИРасходыПредпринимателя(
		Организация, НачалоГода(Период), КонецГода(Период), Декларация3НДФЛВыбраннаяФорма);
	ПараметрыВыполнения.УникальныйИдентификаторФормы = УникальныйИдентификатор;
	
	СведенияОДоходахИВычетах = УчетНДФЛПредпринимателя.СведенияОДоходахИВычетах(ПараметрыВыполнения);
	
	Возврат СведенияОДоходахИВычетах.КоличествоМесяцевВычетНаДетей;
	
КонецФункции

#КонецОбласти
