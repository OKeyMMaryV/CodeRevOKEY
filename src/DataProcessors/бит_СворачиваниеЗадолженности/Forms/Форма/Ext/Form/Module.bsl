﻿

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НедостающиеНастройки = ПолучитьНедостающиеНастройкиОчередностейСворачивания();
	
	Если НедостающиеНастройки.Количество() > 0 Тогда		
		
		ФормаВводаПараметров = ПолучитьФорму("Обработка.бит_СворачиваниеЗадолженности.Форма.ФормаНастроек"); 		
		ТЧНедостающиеНастройкиКоллекция = ФормаВводаПараметров.Объект.ТЧНедостающиеНастройки;
		
		Для Каждого НедоСтрока Из НедостающиеНастройки Цикл
			
			СтрокаКоллекции = ТЧНедостающиеНастройкиКоллекция.Добавить();
			СтрокаКоллекции.ИмяНастройки = Строка(НедоСтрока.Значение);
			
		КонецЦикла;
		
		Предупреждение("Не все параметры заведены в настройках МСФО. Требуется дозаполнить.");
		
		ФормаВводаПараметров.ОткрытьМодально();
		
	КонецЕсли;
	
	ЗаполнитьФормуНастройками();
	
	Элементы.ТабличнаяЧастьНомерСтроки.Доступность = Ложь;
	
	ПроверитьДатуЗапретаРедактирования();
	
КонецПроцедуры

//БИТ Тртилек 12.12.12 получим настройки для заполнения табличной части из регистра бит_му_Настройки
//
&НаСервере
Функция ПолучитьНедостающиеНастройкиОчередностейСворачивания()
	
	НедостающиеСтроки = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ   	               
	               |	бит_му_Настройки.ИмяНастройки,
	               |	бит_му_Настройки.Значение
	               |ИЗ
	               |	РегистрСведений.бит_му_Настройки КАК бит_му_Настройки
	               |ГДЕ
	               |	бит_му_Настройки.Группа = ""Обработка по сворачиванию задолженностей поставщиков товара""";
	ТаблицаНастроек = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ВидОперации Из Перечисления.бит_му_ВидыОперацийСворачиваниеЗадолженности Цикл
		
		Строка = ТаблицаНастроек.Найти(Строка(ВидОперации), "ИмяНастройки");
		
		Если Строка = Неопределено Тогда
			
			НедостающиеСтроки.Добавить(ВидОперации);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НедостающиеСтроки;
	            
КонецФункции

&НаКлиенте
Процедура ЗаполнитьФормуНастройками()
	
	ЗаполнитьФормуНастроекСервер();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуНастроекСервер()
	Объект.ТабличнаяЧасть.Очистить();
	
	НаборНастроек = РегистрыСведений.бит_му_Настройки.СоздатьНаборЗаписей();
	НаборНастроек.Отбор.Группа.Установить("Обработка по сворачиванию задолженностей поставщиков товара");
	НаборНастроек.Прочитать();
	
	ТаблицаИмеющихсяНастроек = НаборНастроек.Выгрузить();
	
	ТаблицаИмеющихсяНастроек.Сортировать("Значение Возр");
	
	СтрокаДляОформления = 0;
	
	Для Каждого Настройка Из ТаблицаИмеющихсяНастроек Цикл
		
		Если Настройка.Значение = "0" ИЛИ НЕ ЗначениеЗаполнено(Настройка.Значение) Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Объект.ТабличнаяЧасть.Добавить();
		НоваяСтрока.ВидОперации = Настройка.ИмяНастройки;
		
		НашаОперация = Неопределено;
		
		Для Каждого ВидОперации Из Перечисления.бит_му_ВидыОперацийСворачиваниеЗадолженности Цикл
			
			ИмяОперации = Настройка.ИмяНастройки;		
			
			Если ИмяОперации = Строка(ВидОперации) Тогда 			
				
				НашаОперация = ВидОперации;
				
			КонецЕсли;
			
		КонецЦикла;
		
		//Подтянем имеющиеся документы сворачивания
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	бит_му_СворачиваниеЗадолженности.Ссылка
		               |ИЗ
		               |	Документ.бит_му_СворачиваниеЗадолженности КАК бит_му_СворачиваниеЗадолженности
		               |ГДЕ
		               |	бит_му_СворачиваниеЗадолженности.Дата МЕЖДУ &ДатаНач И &ДатаКон
		               |	И бит_му_СворачиваниеЗадолженности.ВидОперации = &ВидОперации
		               |	И бит_му_СворачиваниеЗадолженности.ПометкаУдаления = ЛОЖЬ
		               |	И бит_му_СворачиваниеЗадолженности.Проведен = ИСТИНА
		               |	И бит_му_СворачиваниеЗадолженности.Организация = &Организация";
		Запрос.УстановитьПараметр("ДатаНач", НачалоМесяца(Объект.Дата));				   
		Запрос.УстановитьПараметр("ДатаКон", КонецМесяца(Объект.Дата));
		Запрос.УстановитьПараметр("Организация", Объект.Организация);
		Запрос.УстановитьПараметр("ВидОперации", НашаОперация);
		
		Результат = Запрос.Выполнить();
		
		Если Не Результат.Пустой() Тогда
			ВыборкаРез = Результат.Выбрать();
			Если ВыборкаРез.Следующий() Тогда
				Если ВыборкаРез.Количество() = 1 Тогда
					НоваяСтрока.СозданныйДокумент = ВыборкаРез.Ссылка;
					НоваяСтрока.Выполнить = Истина;
					НоваяСтрока.Сделано = Истина;
				Иначе
					Сообщить("В данном месяце уже существуют следующие документы с видом операции " + Настройка.ИмяНастройки + " :", СтатусСообщения.Важное);
					Пока ВыборкаРез.Следующий() Цикл
						Сообщить(Строка(ВыборкаРез.Ссылка));
					КонецЦикла;
					Сообщить("Ссылка на документ заполнена не будет");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		
		Если ЗначениеЗаполнено(НоваяСтрока.СозданныйДокумент) Тогда
			СтрокаДляОформления  = НоваяСтрока.НомерСтроки;		
		КонецЕсли;
				
	КонецЦикла;
	   
	Объект.ТабличнаяЧасть[0].Выполнить = Истина;
	
	Для Ном = 1 По СтрокаДляОформления Цикл
		Если Объект.ТабличнаяЧасть[Ном-1].ВидОперации = "Погашение взаимозачетом проверено" Тогда
			 Объект.ТабличнаяЧасть[Ном-1].Выполнить = Истина;
			 Объект.ТабличнаяЧасть[Ном-1].Сделано   = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.ТабличнаяЧасть.ТекущаяСтрока = СтрокаДляОформления;
	
	УсловноеОформлениеНаСервере(СтрокаДляОформления-1);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокумент(Команда)
	
	Если Элементы.ТабличнаяЧасть.ТекущиеДанные.Выполнить = Ложь Тогда
		
		Сообщить("В текущей строке не установлен признак Выполнить. Документ создан не будет");
		Возврат;
		
	КонецЕсли;
	
	//Для "Погашение взаимозачетом проверено" создавать документ не нужно
	Если Элементы.ТабличнаяЧасть.ТекущиеДанные.ВидОперации = "Погашение взаимозачетом проверено" Тогда
		 Элементы.ТабличнаяЧасть.ТекущиеДанные.Сделано = Истина;
		 УсловноеОформлениеНаСервере(Элементы.ТабличнаяЧасть.ТекущиеДанные.НомерСтроки-1);
		 Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		
		Сообщить("Заполните организацию", СтатусСообщения.Важное);
		Возврат;
		
	КонецЕсли;
	
	ИмяОперации = Элементы.ТабличнаяЧасть.ТекущиеДанные.ВидОперации;		
	ОперацияСоздаваемогоДокумента = ОпределеитьВидОперации(ИмяОперации);
	
	СоздатьДокументСворачивания(ОперацияСоздаваемогоДокумента);

КонецПроцедуры

&НаСервере
Функция ОпределеитьВидОперации(ИмяОперации)
	Для Каждого ВидОперации Из Перечисления.бит_му_ВидыОперацийСворачиваниеЗадолженности Цикл
		
		Если ИмяОперации = Строка(ВидОперации) Тогда 			
			
			Возврат ВидОперации;
			
		КонецЕсли;
		
	КонецЦикла;
	Возврат Неопределено;
	
КонецФункции
 
&НаКлиенте
Процедура СоздатьДокументСворачивания(ВидОперации)
	Перем Параметры;
	
	Проведен = Ложь;
	СсылкаНаДок = ПредопределенноеЗначение("Документ.бит_му_СворачиваниеЗадолженности.ПустаяСсылка");
	СоздатьДокументСворачиванияСервер(ВидОперации, СсылкаНаДок);
	
	Если ЗначениеЗаполнено(СсылкаНаДок) Тогда
		ФормаДокумента = ПолучитьФорму("Документ.бит_му_СворачиваниеЗадолженности.Форма.ФормаДокумента", Новый структура("Ключ", СсылкаНаДок), Неопределено);
		ФормаДокумента.ОткрытьМодально();
		Номер = "";
		Проведен = ОпределитьПроведениеДОкумента(СсылкаНаДок,Номер);
		Если Проведен Тогда	
			
			Сообщить("Документ с номером: " + Номер + 
			" и видом операции: " + Строка(ВидОперации) + " создан и проведен");
			
			Элементы.ТабличнаяЧасть.ТекущиеДанные.Сделано = Истина;
			Элементы.ТабличнаяЧасть.ТекущиеДанные.СозданныйДокумент = СсылкаНаДок;
			
			УсловноеОформлениеНаСервере(Элементы.ТабличнаяЧасть.ТекущиеДанные.НомерСтроки-1);
			
		КонецЕсли;
		
		Если Не Проведен Тогда
			
			Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма, СсылкаНаДок);
			ПоказатьВопрос(Оповещение,"Созданный документ не был проведен. Пометить на удаление?",РежимДиалогаВопрос.ДаНет);
			
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция ОпределитьПроведениеДокумента(Ссылка, Номер)
	Номер = Ссылка.Номер;
	Возврат Ссылка.Проведен;
КонецФункции
 
&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметр) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПометитьДокументНаУдаление(Параметр);
	Иначе
		Сообщить("Документ " + Строка(Параметр.Ссылка.Номер) + " создан, но не проведен.");		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПометитьДокументНаУдаление(Ссылка)
	СозданныйДокумент = Ссылка.ПолучитьОбъект();
	СозданныйДокумент.ПометкаУдаления = Истина; 
	СозданныйДокумент.Записать(РежимЗаписиДокумента.Запись);
КонецПроцедуры
 
&НаСервере
Процедура СоздатьДокументСворачиванияСервер(ВидОперации, СсылкаНаДок)
	
	Существует = Ложь;
	
	ПроверкаСуществованияАналогичныхДокументов(Существует, ВидОперации, Объект.Дата);
	
	Если Существует Тогда 
		Возврат;
	КонецЕсли;
	
	НовыйДокументСворачивания = Документы.бит_му_СворачиваниеЗадолженности.СоздатьДокумент();
	НовыйДокументСворачивания.ВидОперации = ВидОперации;
	НовыйДокументСворачивания.Дата = КонецМесяца(Объект.Дата);
	НовыйДокументСворачивания.Организация = Объект.Организация;
	НовыйДокументСворачивания.Ответственный = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь");
	НовыйДокументСворачивания.Записать(РежимЗаписиДокумента.Запись);
	СсылкаНаДок = НовыйДокументСворачивания.Ссылка;
	
КонецПроцедуры

&НаСервере
Процедура ПроверкаСуществованияАналогичныхДокументов(Существует, ВидОперации, ДатаОбработки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_му_СворачиваниеЗадолженности.Ссылка
	               |ИЗ
	               |	Документ.бит_му_СворачиваниеЗадолженности КАК бит_му_СворачиваниеЗадолженности
	               |ГДЕ
	               |	бит_му_СворачиваниеЗадолженности.Дата МЕЖДУ &ДатаНач И &ДатаКон
	               |	И бит_му_СворачиваниеЗадолженности.ВидОперации = &ВидОперации
	               |	И бит_му_СворачиваниеЗадолженности.Организация = &Организация";
	Запрос.УстановитьПараметр("ДатаНач", НачалоМесяца(ДатаОбработки));				   
	Запрос.УстановитьПараметр("ДатаКон", КонецМесяца(ДатаОбработки));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ВидОперации", ВидОперации);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Существует = Истина;
		Сообщить("В данном месяце по организации: " + Объект.Организация + " уже существуют следующие документы с видом операции " + Строка(ВидОперации) + " :", СтатусСообщения.Важное);
		ВыборкаРез = Результат.Выбрать();
		Пока ВыборкаРез.Следующий() Цикл
			Сообщить(Строка(ВыборкаРез.Ссылка));
		КонецЦикла;
		Сообщить("Документ создан не будет");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УсловноеОформлениеНаСервере(ТекНомер)
	
	мУсловноеОформление = ЭтаФорма.УсловноеОформление;
	
	мУсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = мУсловноеОформление.Элементы.Добавить();
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ТабличнаяЧастьВыполнить");
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТабличнаяЧасть.НомерСтроки");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ЭлементОтбора.ПравоеЗначение = ТекНомер+2;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
		
	Для Ном = 1 По ТекНомер+1 Цикл
		ЭлементУсловногоОформленияКрасим = мУсловноеОформление.Элементы.Добавить();
		ОформляемоеПоле = ЭлементУсловногоОформленияКрасим.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ТабличнаяЧастьНомерСтроки");
		ОформляемоеПоле = ЭлементУсловногоОформленияКрасим.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ТабличнаяЧастьВидОперации");
		ОформляемоеПоле = ЭлементУсловногоОформленияКрасим.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ТабличнаяЧастьВыполнить");
		ОформляемоеПоле = ЭлементУсловногоОформленияКрасим.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ТабличнаяЧастьСделано");
		ОформляемоеПоле = ЭлементУсловногоОформленияКрасим.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ТабличнаяЧастьСозданныйДокумент");
		ЭлементОтбора = ЭлементУсловногоОформленияКрасим.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТабличнаяЧасть.НомерСтроки");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Ном;
		ЭлементУсловногоОформленияКрасим.Оформление.УстановитьЗначениеПараметра("ЦветФона", Новый Цвет(222,222,222));   
	КонецЦикла;
	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мТекущаяСтрокаТаблицы = 1;
	
	Объект.Дата = КонецДня(ТекущаяДата());
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьПриАктивизацииСтроки(Элемент)
	
	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВидОперации(ВидОперацииСтрока)
	
	ОперацияСоздаваемогоДокумента = Неопределено;
	
	Для Каждого ВидОперации Из Перечисления.бит_му_ВидыОперацийСворачиваниеЗадолженности Цикл		
		
		Если Строка(ВидОперации) = ВидОперацииСтрока Тогда 			
			
			ОперацияСоздаваемогоДокумента = ВидОперации;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ОперацияСоздаваемогоДокумента;
	
КонецФункции

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЗаполнитьФормуНастройками();
	
	ПроверитьДатуЗапретаРедактирования();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ЗаполнитьФормуНастройками();
	
	ПроверитьДатуЗапретаРедактирования();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьГраницуЗапрета()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_ДатыЗапретаРедактирования.ДатаЗапрета,
	               |	2 КАК Приоритет
	               |ИЗ
	               |	РегистрСведений.бит_ДатыЗапретаРедактирования КАК бит_ДатыЗапретаРедактирования
	               |ГДЕ
	               |	бит_ДатыЗапретаРедактирования.Организация = &Организация
	               |	И бит_ДатыЗапретаРедактирования.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	               |	И бит_ДатыЗапретаРедактирования.ОбъектСистемы В(&ПустыеСсылки)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	бит_ДатыЗапретаРедактирования.ДатаЗапрета,
	               |	1
	               |ИЗ
	               |	РегистрСведений.бит_ДатыЗапретаРедактирования КАК бит_ДатыЗапретаРедактирования
	               |ГДЕ
	               |	бит_ДатыЗапретаРедактирования.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	               |	И бит_ДатыЗапретаРедактирования.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	               |	И бит_ДатыЗапретаРедактирования.ОбъектСистемы В(&ПустыеСсылки)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	бит_ДатыЗапретаРедактирования.ДатаЗапрета,
	               |	3
	               |ИЗ
	               |	РегистрСведений.бит_ДатыЗапретаРедактирования КАК бит_ДатыЗапретаРедактирования
	               |ГДЕ
	               |	бит_ДатыЗапретаРедактирования.Организация = &Организация
	               |	И бит_ДатыЗапретаРедактирования.Пользователь = &ТекПользователь
	               |	И бит_ДатыЗапретаРедактирования.ОбъектСистемы В(&ПустыеСсылки)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	бит_ДатыЗапретаРедактирования.ДатаЗапрета,
	               |	4
	               |ИЗ
	               |	РегистрСведений.бит_ДатыЗапретаРедактирования КАК бит_ДатыЗапретаРедактирования
	               |ГДЕ
	               |	бит_ДатыЗапретаРедактирования.Организация = &Организация
	               |	И бит_ДатыЗапретаРедактирования.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	               |	И бит_ДатыЗапретаРедактирования.ОбъектСистемы = &ОбъектСистемы
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	бит_ДатыЗапретаРедактирования.ДатаЗапрета,
	               |	5
	               |ИЗ
	               |	РегистрСведений.бит_ДатыЗапретаРедактирования КАК бит_ДатыЗапретаРедактирования
	               |ГДЕ
	               |	бит_ДатыЗапретаРедактирования.Организация = &Организация
	               |	И бит_ДатыЗапретаРедактирования.Пользователь = &ТекПользователь
	               |	И бит_ДатыЗапретаРедактирования.ОбъектСистемы = &ОбъектСистемы
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Приоритет";
	Запрос.УстановитьПараметр("ОбъектСистемы", Справочники.бит_ОбъектыСистемы.НайтиПоНаименованию(Метаданные.Документы.бит_му_СворачиваниеЗадолженности.Синоним));
	Запрос.УстановитьПараметр("ТекПользователь", ПараметрыСеанса.ТекущийПользователь);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	ПустыеСсылки = Новый СписокЗначений;
	ПустыеСсылки.Добавить(Неопределено);
	ПустыеСсылки.Добавить(Справочники.бит_ОбъектыСистемы.ПустаяСсылка());
	ПустыеСсылки.Добавить(Справочники.бит_ГруппыОбъектовСистемы.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустыеСсылки", ПустыеСсылки);
	
	ЗапросВыполнить = Запрос.Выполнить();
	Если ЗапросВыполнить.Пустой() Тогда
		Граница = Дата(1,1,1);
	Иначе
		Рез = ЗапросВыполнить.Выбрать();
		Пока Рез.Следующий() Цикл
			Граница = Рез.ДатаЗапрета;
		КонецЦикла; 
	КонецЕсли;
	Возврат Граница;
КонецФункции

&НаКлиенте
Процедура ПроверитьДатуЗапретаРедактирования()  	

	ГраницаПоОрганизации = ПолучитьГраницуЗапрета();
	
	Если НЕ ГраницаПоОрганизации = Неопределено 
		И Объект.Дата <= ГраницаПоОрганизации	Тогда
		
		Элементы.НадписьДатыЗапрета.Заголовок = "В данном периоде запрещено создавать документы, т.к. он закрыт.";			
		Элементы.КнопкаВыполнить.Доступность = Ложь;
	Иначе
		Элементы.НадписьДатыЗапрета.Заголовок = "";
		Элементы.КнопкаВыполнить.Доступность = Истина;
	КонецЕсли;		
	

	//НастройкаПравДоступа.ПроверитьВерсиюДокумента(ДокументОбъект, ПараметрыПроверкиДокумента, СоответствиеГраницЗапрета, ФормаДокумента.ТолькоПросмотр);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ПриОткрытии(Ложь);
	
КонецПроцедуры
