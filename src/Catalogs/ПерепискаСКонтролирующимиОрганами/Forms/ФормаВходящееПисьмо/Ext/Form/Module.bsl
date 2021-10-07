﻿&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Вложения.ЗагрузитьЗначения(ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ПолучитьСписокВложений(Объект.Ссылка));
	
	Если ЗаполнитьВложенияИзТекстаПисьма(Объект.Содержание, Вложения, Объект.Ссылка) Тогда
		Содержание = ПреобразоватьТекстПисьма(Объект.Содержание);
	Иначе
		Содержание = Объект.Содержание;
	КонецЕсли;
	
	Элементы.Вложения.Заголовок = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ФорматированноеПредставлениеСпискаВложений(Вложения.ВыгрузитьЗначения());
	Заголовок = Объект.Наименование;
	
	УправлениеФормой(ЭтаФорма);
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ПерепискаСКонтролирующимиОрганами",, Объект.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСохранитьВложения(Команда)
	
	СохранитьВложения();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтветить(Команда)
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("КомандаОтветитьЗавершение", ЭтотОбъект);
		ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	Иначе
		КонтекстЭДОКлиент.СоздатьПисьмоОтвет(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветитьПакетом(Команда)
	
	КонтекстЭДОКлиент.СоздатьПакетСДопДокуменами(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтветитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	КонтекстЭДОКлиент.СоздатьПисьмоОтвет(Объект.Ссылка);

КонецПроцедуры

&НаКлиенте
Процедура ВложенияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИмяФайла = НавигационнаяСсылкаФорматированнойСтроки;
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура("ИмяФайла", ИмяФайла);
		ОписаниеОповещения = Новый ОписаниеОповещения("ВложенияОбработкаНавигационнойСсылкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	Иначе
		ОбработатьВложениеНавигационнойСсылки(ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияОбработкаНавигационнойСсылкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	ИмяФайла = ДополнительныеПараметры.ИмяФайла;
	ОбработатьВложениеНавигационнойСсылки(ИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВложениеНавигационнойСсылки(ИмяФайла)
	
	Если ЭтоГиперссылка(ИмяФайла) Тогда
		Результат = ПолучитьВложениеПоСсылкеНаСервере(ИмяФайла);
		Если Не Результат.Выполнено Тогда
			ПоказатьПредупреждение(,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось скачать вложение
                                                                              |%1'"), ИмяФайла));
		Иначе
			ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(
				Результат.Хранение, 
				ОбщегоНазначенияЭДКОКлиентСервер.ЗаменитьЗапрещенныеСимволыВИмениФайла(Результат.Имя));
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	РасширениеФайла = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяФайла);
	Если НРег(РасширениеФайла) = "txt" Тогда
		ВАрхиве = Ложь;
		Результат = ПолучитьТекстовоеВложение(Объект.Ссылка, ИмяФайла, ВАрхиве);
		Если Результат = Неопределено И ВАрхиве Тогда
			КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(, 9, 3, Истина);
		ИначеЕсли Результат = Неопределено Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вложение с именем 
			|%1
			|не обнаружено.'"), ИмяФайла));
		Иначе
			ПоказатьЗначение(, Результат);
		КонецЕсли;
	Иначе
		ВАрхиве = Ложь;
		Результат = ПолучитьВложениеНаСервере(Объект.Ссылка, ИмяФайла, УникальныйИдентификатор, ВАрхиве);
		Если Результат = Неопределено И ВАрхиве Тогда
			КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(, 9, 3, Истина);
		ИначеЕсли Результат = Неопределено Тогда
			ПоказатьПредупреждение(,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вложение с именем 
			|%1
			|не обнаружено.'"), ИмяФайла));
		Иначе
			ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(
				Результат, 
				ОбщегоНазначенияЭДКОКлиентСервер.ЗаменитьЗапрещенныеСимволыВИмениФайла(ИмяФайла));
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	ПечатнаяФормаПисьма = ТабличныйДокументПисьма(Объект.Ссылка);
	КонтекстЭДОКлиент.НапечататьДокумент(ПечатнаяФормаПисьма, Объект.Наименование);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоГиперссылка(СтрокаДляПроверки)
	
	Возврат СтрНайти(НРег(СтрокаДляПроверки), "http://") ИЛИ СтрНайти(НРег(СтрокаДляПроверки), "https://");
	
КонецФункции
	
&НаСервереБезКонтекста
Функция ЗаполнитьВложенияИзТекстаПисьма(ТекстПисьма, Вложения, Ссылка)
	
	Результат = Истина;
	Попытка
		Если СтрНайти(ТекстПисьма, "Вложения:") И СтрНайти(ТекстПисьма, "http") Тогда
			Для ИндексСтроки = 1 По СтрЧислоСтрок(ТекстПисьма) Цикл
				ТекущаяСтрока = СтрПолучитьСтроку(ТекстПисьма, ИндексСтроки);	
				
				Если ЭтоГиперссылка(ТекущаяСтрока) Тогда
					ИмяФайлаСРазмером = СтрПолучитьСтроку(ТекстПисьма, ИндексСтроки - 1);
					ПозицияСкобки = СтрНайти(ИмяФайлаСРазмером, "(", НаправлениеПоиска.СКонца);
					ИмяФайла = Лев(ИмяФайлаСРазмером, ПозицияСкобки - 1);
					РазмерСтрокой = Сред(ИмяФайлаСРазмером, ПозицияСкобки + 1, СтрДлина(ИмяФайлаСРазмером) - ПозицияСкобки - 1);
					Если СтрНайти(РазмерСтрокой, "K") ИЛИ СтрНайти(РазмерСтрокой, "К") Тогда
						Множитель = 1024;
					ИначеЕсли СтрНайти(РазмерСтрокой, "М") ИЛИ СтрНайти(РазмерСтрокой, "M") Тогда
						Множитель = 1024 * 1024;
					ИначеЕсли СтрНайти(РазмерСтрокой, "G") ИЛИ СтрНайти(РазмерСтрокой, "Г") Тогда
						Множитель = 1024 * 1024 * 1024;
					Иначе
						Множитель = 1;
					КонецЕсли;
					ЗаменяемыеСимволы = "БКМГ BKMG";
					Для Индекс = 1 По СтрДлина(ЗаменяемыеСимволы) Цикл
						РазмерСтрокой = СтрЗаменить(РазмерСтрокой, Сред(ЗаменяемыеСимволы, Индекс, 1), "");
					КонецЦикла;
					Размер = Число(РазмерСтрокой) * Множитель;
					
					СвойстваВложения = Новый Структура("ИмяФайла,Размер,Ссылка", ИмяФайла, Размер, ТекущаяСтрока);
					Вложения.Добавить(СвойстваВложения);
				КонецЕсли;			
			КонецЦикла;
		КонецЕсли;
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронный документооборот с контролирующими органами.Анализ текста письма рассылки'", 
				ОбщегоНазначения.КодОсновногоЯзыка()),
		    УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Справочники.ПерепискаСКонтролирующимиОрганами,
			Ссылка,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПреобразоватьТекстПисьма(ТекстПисьма)
	
	НовыйТекстПисьма = ТекстПисьма;
	Если СтрНайти(ТекстПисьма, "Вложения:") И СтрНайти(ТекстПисьма, "http") Тогда
		НовыйТекстПисьма = СокрЛП(Лев(ТекстПисьма, СтрНайти(ТекстПисьма, "Вложения:") - 1));	
	КонецЕсли;
	
	Возврат НовыйТекстПисьма;
		
КонецФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТабличныйДокументПисьма(Письмо)
	
	Возврат Справочники.ПерепискаСКонтролирующимиОрганами.ПечатнаяФорма(Письмо);

КонецФункции

&НаКлиенте
Процедура СохранитьВложения()
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьВложенияЗавершение", ЭтотОбъект);
		ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	Иначе
		СохранитьВложенияЗавершение(Неопределено, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьВложения(Всего, ВАрхиве)
	
	КонтекстМодуля = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	ВложенияОснования = КонтекстМодуля.ПолучитьВложенияНеформализованногоДокумента(Объект.Ссылка,, Ложь);
	
	Всего = 0;
	ВАрхиве = 0;
	
	Для Каждого Вложение Из ВложенияОснования Цикл 
		ВАрхиве = ВАрхиве + ?(Вложение.ВАрхиве, 1, 0);
		Всего = Всего + 1;
	КонецЦикла;
	
КонецПроцедуры
		
&НаКлиенте
Процедура СохранитьВложенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	КонецЕсли;
	
	МассивВложений = Новый Массив;
	Для Каждого Элемент Из Вложения Цикл
		МассивВложений.Добавить(Элемент.Значение);
	КонецЦикла;
	
	Если МассивВложений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Всего = 0;
	ВАрхиве = 0;
	ПроверитьВложения(Всего, ВАрхиве);
	
	ВхПараметры = Новый Структура("МассивВложений", МассивВложений);
	
	Если ВАрхиве > 0 Тогда 
		ВсеВАрхиве = ?(ВАрхиве = Всего, 1, 0);		
		Описание = Новый ОписаниеОповещения("СохранитьВложенияПослеПроверкиЗавершение", ЭтотОбъект, ВхПараметры);
		КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(Описание, 18 + ВсеВАрхиве, 0, ?(ВсеВАрхиве = 1, Истина, Ложь));
		Возврат;
	КонецЕсли;
	
	СохранитьВложенияПослеПроверкиЗавершение(КодВозвратаДиалога.Да, ВхПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВложенияПослеПроверкиЗавершение(Результат, ВхПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда 
		МассивОписанийПолучаемыеФайлы = ПолучитьМассивОписанийФайловВложений(
			Объект.Ссылка, ВхПараметры.МассивВложений, УникальныйИдентификатор);
		
		Если МассивОписанийПолучаемыеФайлы.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
	
		ОперацииСФайламиЭДКОКлиент.СохранитьФайлы(МассивОписанийПолучаемыеФайлы);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМассивОписанийФайловВложений(Ссылка, МассивВложений, Идентификатор)
	
	МассивОписаний = Новый Массив;
	
	Для Каждого Вложение Из МассивВложений Цикл
		Если Вложение.Свойство("Ссылка") Тогда
			Результат = ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(Вложение.Ссылка);
			Если Не Результат.Статус Тогда
				ОбщегоНазначения.СообщитьПользователю(Результат.СообщениеОбОшибке);
			Иначе
				АдресДанных = Результат.Путь;
			КонецЕсли;			
		Иначе
			АдресДанных = ПолучитьВложениеНаСервере(Ссылка, Вложение.ИмяФайла, Идентификатор);
		КонецЕсли;
		Если ЗначениеЗаполнено(АдресДанных) Тогда 
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(
				ОбщегоНазначенияЭДКОКлиентСервер.ЗаменитьЗапрещенныеСимволыВИмениФайла(Вложение.ИмяФайла), 
				АдресДанных); 
			МассивОписаний.Добавить(ОписаниеФайла);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат МассивОписаний;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	ПрорисоватьСтатус(Форма);
	
	ЕстьВложения = Форма.Вложения.Количество() > 0;
	
	Элементы.КомандаСохранитьВложения.Видимость = ЕстьВложения;
	Элементы.ЗаголовокВложения.Видимость = ЕстьВложения;
	Элементы.Вложения.Видимость = ЕстьВложения;
	
	Элементы.Содержание.Видимость = ЗначениеЗаполнено(Объект.Содержание);
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	ТребуетсяОтправкаПакета = КонтекстЭДОСервер.ТребуетсяОтправкаПакетаСДопДокументами(Объект.Ссылка); 
	
	Элементы.ОтветитьПисьмом.Видимость = НЕ ТребуетсяОтправкаПакета;
	Элементы.ГруппаОтвета.Видимость    = ТребуетсяОтправкаПакета;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТекстовоеВложение(Ссылка, ИмяФайла, ВАрхиве)
	
	Возврат Справочники.ПерепискаСКонтролирующимиОрганами.ПолучитьТекстовоеВложение(Ссылка, ИмяФайла, ВАрхиве);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВложениеНаСервере(Ссылка, ИмяФайла, УникальныйИдентификатор, ВАрхиве = Ложь)
	
	Возврат Справочники.ПерепискаСКонтролирующимиОрганами.ПолучитьВложениеНаСервере(Ссылка, ИмяФайла, УникальныйИдентификатор, ВАрхиве);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПрорисоватьСтатус(Форма)
	
	ВидКонтролирующегоОргана = ИмяТекущегоТипаПолучателя(Форма.Объект.Тип);
	
	ПараметрыПрорисовкиПанелиОтправки = ДокументооборотСКОВызовСервера.ПараметрыПрорисовкиПанелиОтправки(Форма.Объект.Ссылка, Форма.Объект.Организация, ВидКонтролирующегоОргана);
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПрименитьПараметрыПрорисовкиПанелиОтправки(Форма, ПараметрыПрорисовкиПанелиОтправки);
	
	Форма.Элементы.СостояниеОтправки.Видимость = Ложь;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяТекущегоТипаПолучателя(ТипПолучателя)
	
	Если ЗначениеЗаполнено(ТипПолучателя) Тогда
		Если ТипПолучателя = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСФНС") Тогда
			ВидКонтролирующегоОргана = "ФНС";
		ИначеЕсли ТипПолучателя = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСПФР") Тогда
			ВидКонтролирующегоОргана = "ПФР";
		ИначеЕсли ТипПолучателя = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСФСГС") Тогда
			ВидКонтролирующегоОргана = "ФСГС";
		КонецЕсли;
	Иначе
		Возврат "ФНС";
	КонецЕсли;
	
	Возврат ВидКонтролирующегоОргана;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВложениеПоСсылкеНаСервере(Ссылка)
	
	РезультатВыполнения = Новый Структура("Выполнено", Ложь);
	Результат = ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(Ссылка);
	Если Не Результат.Статус Тогда
		ОбщегоНазначения.СообщитьПользователю(Результат.СообщениеОбОшибке);
	Иначе
		РезультатВыполнения.Выполнено = Истина;
		РезультатВыполнения.Вставить("Имя", Сред(Ссылка, СтрНайти(Ссылка, "/", НаправлениеПоиска.СКонца) + 1));
		РезультатВыполнения.Вставить("Хранение", Результат.Путь);		
	КонецЕсли;	
	
	Возврат РезультатВыполнения;
	
КонецФункции

#КонецОбласти

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтаФорма, ИмяТекущегоТипаПолучателя(ЭтаФорма.Объект.Тип));
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтаФорма, ИмяТекущегоТипаПолучателя(ЭтаФорма.Объект.Тип));
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтаФорма, ИмяТекущегоТипаПолучателя(ЭтаФорма.Объект.Тип));
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтаФорма, ИмяТекущегоТипаПолучателя(ЭтаФорма.Объект.Тип));
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтаФорма, ИмяТекущегоТипаПолучателя(ЭтаФорма.Объект.Тип));
КонецПроцедуры



#КонецОбласти