#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс
	
// Функция извлекает настройки внутренней миграции для объекта обмена.
// 
// Параметры:
//  ОписаниеОбъекта - СправочникСсылка.бит_мдм_ОписанияОбъектовОбмена.
// 
// Возвращаемое значение:
//  Настройки - Структура.
// 
Функция ПолучитьНастройкиВнутреннейМиграции(ОписаниеОбъекта) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Приемник", ОписаниеОбъекта);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_мдм_ПравилаРегистрацииИзменений.Приемник,
	               |	бит_мдм_ПравилаРегистрацииИзменений.РежимОбработки,
	               |	бит_мдм_ПравилаРегистрацииИзменений.РежимИзменения
	               |ИЗ
	               |	РегистрСведений.бит_мдм_ПравилаРегистрацииИзменений КАК бит_мдм_ПравилаРегистрацииИзменений
	               |ГДЕ
	               |	бит_мдм_ПравилаРегистрацииИзменений.Приемник = &Приемник
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	бит_мдм_ОписанияРеквизитовОбъектовОбмена.Ссылка КАК ОписаниеРеквизита,
	               |	бит_мдм_ОписанияРеквизитовОбъектовОбмена.Вид,
	               |	бит_мдм_ОписанияРеквизитовОбъектовОбмена.ТипЗнчСтр,
	               |	бит_мдм_ОписанияРеквизитовОбъектовОбмена.Обязательный,
	               |	бит_мдм_ОписанияРеквизитовОбъектовОбмена.Имя,
	               |	бит_мдм_ОписанияРеквизитовОбъектовОбмена.ВидОбъекта,
	               |	бит_мдм_ОписанияРеквизитовОбъектовОбмена.ИмяОбъекта,
	               |	бит_мдм_ОписанияРеквизитовОбъектовОбмена.Составной
	               |ИЗ
	               |	Справочник.бит_мдм_ОписанияРеквизитовОбъектовОбмена КАК бит_мдм_ОписанияРеквизитовОбъектовОбмена
	               |ГДЕ
	               |	бит_мдм_ОписанияРеквизитовОбъектовОбмена.Владелец = &Приемник";
				   
	МассивРезультатов = Запрос.ВыполнитьПакет();
	МассивНастроек = Новый Массив;
	
	Выборка = МассивРезультатов[0].Выбрать();
	
	РежимОбработки = Перечисления.бит_мдм_РежимыОбработки.Регламентный;
	РежимИзменения = Перечисления.бит_мдм_РежимыИзменения.Обычный;
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.Приемник) Тогда
			
			РежимОбработки = Выборка.РежимОбработки;
			РежимИзменения = Выборка.РежимИзменения;
			
			ОписаниеНастройки = Новый Структура;
			ОписаниеНастройки.Вставить("РежимОбработки", Выборка.РежимОбработки);
			ОписаниеНастройки.Вставить("РежимИзменения", Выборка.РежимИзменения);
			
			МассивНастроек.Добавить(ОписаниеНастройки);
			
		КонецЕсли; 
		
	КонецЦикла; 
	
	ОписанияРеквизитов = Новый Структура;
	Выборка = МассивРезультатов[1].Выбрать();
	Пока Выборка.Следующий() Цикл
	
		 Описание = Новый Структура;
		 Описание.Вставить("Описание"    , Выборка.ОписаниеРеквизита);
		 Описание.Вставить("Имя"         , Выборка.Имя);
		 Описание.Вставить("Вид"         , Выборка.Вид);
		 Описание.Вставить("ТипЗнчСтр"   , Выборка.ТипЗнчСтр);
		 Описание.Вставить("Обязательный", Выборка.Обязательный);
		 Описание.Вставить("ИмяОбъекта"  , Выборка.ИмяОбъекта);
		 Описание.Вставить("ВидОбъекта"  , Выборка.ВидОбъекта);
		 Описание.Вставить("Составной"   , Выборка.Составной);
		 
		 
		 ОписанияРеквизитов.Вставить(Выборка.Имя, Описание);
	
	КонецЦикла; 

	
	Настройки = Новый Структура;
	Настройки.Вставить("Элементы", МассивНастроек);
	Настройки.Вставить("Выполнять", Не МассивРезультатов[0].Пустой());
	Настройки.Вставить("РежимОбработки", РежимОбработки);
	Настройки.Вставить("РежимИзменения", РежимИзменения);
	Настройки.Вставить("ОписанияРеквизитов", ОписанияРеквизитов);
	Настройки.Вставить("ОписаниеОбъекта", ОписаниеОбъекта);
	Настройки.Вставить("ПсевдоМета", Справочники.бит_мдм_ОписанияОбъектовОбмена.ЭмулироватьМетаданные(ОписаниеОбъекта, "Структура"));

	Возврат Настройки;
	
КонецФункции // ПолучитьНастройкиВнутреннейМиграции()

// Функция назначает правила регистрации, если они еще не назначены.
// 
// Параметры:
//    вхВидОбъекта - Строка, ПеречислениеСсылка.бит_мдм_ВидыОбъектовОбмена
//    ИмяОбъекта - Строка.
// 
// Возвращаемое значение:
//  флСтатус - Число.
// 
Функция НазначитьПравило(вхВидОбъекта, ИмяОбъекта, РежимСообщений = "Все") Экспорт
	
	РежимыВывода = бит_ОбщегоНазначения.ОпределитьРежимыВывода(РежимСообщений);
	
	флСтатус = 0;
	
	Если ТипЗнч(вхВидОбъекта) = Тип("ПеречислениеСсылка.бит_мдм_ВидыОбъектовОбмена") Тогда
		
		ВидОбъекта = вхВидОбъекта;
		
	Иначе	
		
		ВидОбъекта = Перечисления.бит_мдм_ВидыОбъектовОбмена[вхВидОбъекта];
		
	КонецЕсли; 
	
	ВидИБ = Справочники.бит_мпд_ВидыИнформационныхБаз.ТекущаяИнформационнаяБаза;
	ОписаниеОбъекта = Справочники.бит_мдм_ОписанияОбъектовОбмена.НайтиЭлемент(ВидИБ, ВидОбъекта, ИмяОбъекта);
	
	Если ЗначениеЗаполнено(ОписаниеОбъекта) Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Приемник", ОписаниеОбъекта);
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		|	бит_мдм_ПравилаРегистрацииИзменений.Приемник,
		|	бит_мдм_ПравилаРегистрацииИзменений.РежимОбработки,
		|	бит_мдм_ПравилаРегистрацииИзменений.РежимИзменения
		|ИЗ
		|	РегистрСведений.бит_мдм_ПравилаРегистрацииИзменений КАК бит_мдм_ПравилаРегистрацииИзменений
		|ГДЕ
		|	бит_мдм_ПравилаРегистрацииИзменений.Приемник = &Приемник";
		
		Результат = Запрос.Выполнить();				
		
		Если Результат.Пустой() Тогда
			
			МенеджерЗаписи = РегистрыСведений.бит_мдм_ПравилаРегистрацииИзменений.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Приемник = ОписаниеОбъекта;
			МенеджерЗаписи.РежимИзменения = Перечисления.бит_мдм_РежимыИзменения.Обычный;
			МенеджерЗаписи.РежимОбработки = Перечисления.бит_мдм_РежимыОбработки.Регламентный;
			
			Попытка
				
				МенеджерЗаписи.Записать();
				флСтатус = 2;
				
				Если РежимыВывода.ВыводитьИнформацию Тогда
					
					ТекстСообщения = НСтр("ru = 'Назначена регистрация изменений для объекта обмена ""%1%""'");
					ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ОписаниеОбъекта);
					бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
					
				КонецЕсли; 
				
				
			Исключение
				
				Если РежимыВывода.ВыводитьОшибки Тогда
					
					ТекстСообщения = НСтр("ru = 'Не удалось назначить регистрацию изменений для объекта обмена ""%1%""!'");
					ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ОписаниеОбъекта);
					бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
					
				КонецЕсли; 
				
				флСтатус = -1;
				
			КонецПопытки;
			
		Иначе
			
			// Уже создано
			флСтатус = 1;
			
			Если РежимыВывода.ВыводитьИнформацию Тогда
				
				ТекстСообщения = НСтр("ru = 'Для объекта обмена ""%1%"" регистрация изменений уже назначена.'");
				ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ОписаниеОбъекта);
				бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
				
			КонецЕсли; 
			
		КонецЕсли; 
		
	КонецЕсли; 
	
	Возврат флСтатус;
	
КонецФункции // НазначитьПравило()

#КонецОбласти

#КонецЕсли
